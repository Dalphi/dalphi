class RawDatum < ApplicationRecord
  include Swagger::Blocks

  MIME_TYPES = {
    text: [
      'text/plain',
      'text/markdown',
      'text/html',
      'text/rtf',
      'application/json'
    ],
  }
  MIME_TYPES_LIST = MIME_TYPES.values.flatten
  SHAPES = MIME_TYPES.keys.map(&:to_s)

  belongs_to :project
  has_many :annotation_documents,
           dependent: :destroy
  has_attached_file :data
  before_create :destroy_raw_datum_with_same_filename
  before_update :set_filename

  swagger_schema :RawDatum do
    key :required,
        [
          :shape,
          :data,
          :project_id,
          :filename
        ]

    property :id do
      key :description, I18n.t('api.raw_datum.description.id')
      key :type, :integer
    end

    property :shape do
      key :description, I18n.t('api.raw_datum.description.shape')
      key :type, :string
    end

    property :data do
      key :description, I18n.t('api.raw_datum.description.data')
      key :example, 'RGkgMTAuIEphbiAxNTozMDowNCBDRVQgMjAxNwo='
      key :type, :string
    end

    property :filename do
      key :description, I18n.t('api.raw_datum.description.filename')
      key :type, :string
    end

    property :project_id do
      key :description, I18n.t('api.raw_datum.description.project_id')
      key :type, :integer
    end
  end

  validates :project,
    presence: true

  validates :filename,
    presence: true

  validates :shape,
    presence: true,
    inclusion: { in: SHAPES }

  validates :data,
    attachment_presence: true

  validates_attachment :data,
    content_type: {
      content_type: MIME_TYPES_LIST
    }

  def self.batch_process(project, data)
    return { error: [], success: [] } unless data || data == []
    data_size = data.size
    data_first = data.first.tempfile
    if data_size == 1 && valid_zip?(data_first)
      batch_result = RawDatum.zip_to_data project, data_first.path
    elsif data_size >= 1
      batch_data = []
      data.each do |datum|
        batch_data << { filename: datum.original_filename, path: datum.path }
      end
      batch_result = RawDatum.batch_create project, batch_data
    end
    batch_result
  end

  def self.zip_to_data(project, zip)
    temp_dir = Dir.mktmpdir
    batch_result = { success: [], error: [] }
    begin
      batch_result = process_zip_archive project, zip, temp_dir
    ensure
      FileUtils.remove_entry temp_dir
    end
    batch_result
  end

  def self.process_zip_archive(project, zip, temp_dir)
    require 'zip'
    batch_result = { success: [], error: [] }
    Zip::File.open(zip) do |zipfile|
      zipfile.each do |file|
        filename, extraction_filename = convert_filename(file)
        next unless filename && extraction_filename
        zipfile.extract(filename, "#{temp_dir}/#{extraction_filename}")
        raw_datum = RawDatum.new(
          project: project,
          shape: SHAPES.first,
          filename: filename.force_encoding('utf-8'),
          data: File.open("#{temp_dir}/#{extraction_filename.force_encoding('utf-8')}")
        )
        batch_result = process_result(raw_datum, filename, batch_result)
      end
    end
    batch_result
  end

  def self.convert_filename(file)
    filename = file.to_s
    return false, false if filename =~ /\/$/
    extraction_filename = filename.gsub(/\//, '∕') # be aware that the slash is replaced by U+2215
    return filename, extraction_filename
  end

  def self.encode_filename(filename)
    ActiveSupport::Multibyte::Unicode.normalize(filename)
  end

  def self.process_result(raw_datum, filename, batch_result)
    encoded_filename = encode_filename(filename)
    if raw_datum.save
      batch_result[:success] << encoded_filename
    else
      batch_result[:error] << encoded_filename
    end
    batch_result
  end

  def self.batch_create(project, data)
    batch_result = { success: [], error: [] }
    data.each do |datum|
      raw_datum = RawDatum.create_with_safe_filename(project, datum)
      if raw_datum
        batch_result[:success] << raw_datum.filename
      else
        batch_result[:error] << datum[:filename]
      end
    end
    batch_result
  end

  def update_with_safe_filename(datum)
    filename = datum[:filename]
    self.filename = filename.force_encoding('utf-8')
    self.data = File.open(datum[:path])
    self.data_file_name = self.filename
    return self if self.save
    nil
  end

  def self.create_with_safe_filename(project, datum)
    filename = datum[:filename]
    raw_datum = RawDatum.new(
      project: project,
      shape: SHAPES.first,
      filename: filename.force_encoding('utf-8'),
      data: File.open(datum[:path])
    )
    raw_datum.data_file_name = filename
    return raw_datum if raw_datum.save
    nil
  end

  def label
    self.filename
  end

  def self.valid_zip?(file)
    zip = Zip::File.open(file)
    true
  rescue StandardError
    false
  ensure
    zip.close if zip
  end

  def relevant_attributes
    {
      id: id,
      shape: shape,
      data: Base64.encode64(Paperclip.io_adapters.for(data).read),
      filename: filename,
      project_id: project_id
    }
  end

  private

  def destroy_raw_datum_with_same_filename
    RawDatum.where(
      project: self.project,
      filename: self.filename
    ).destroy_all
  end

  def set_filename
    self.filename = self.data.original_filename
  end
end
