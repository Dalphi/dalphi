class RawDatum < ApplicationRecord
  MIME_TYPES = {
    text: [
      'text/plain',
      'text/markdown',
      'text/html',
      'text/rtf'
    ],
  }
  MIME_TYPES_LIST = MIME_TYPES.values.flatten
  SHAPES = MIME_TYPES.keys.map(&:to_s)

  belongs_to :project
  has_many :annotation_documents,
           dependent: :destroy
  has_attached_file :data

  validates :project,
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
    data_size = data.size
    data_first = data.first
    if data_size == 1 && data_first.content_type =~ /\Aapplication/
      batch_result = RawDatum.zip_to_data project, data_first.tempfile.path
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
          data: File.open("#{temp_dir}/#{extraction_filename.force_encoding('utf-8')}")
        )
        batch_result = process_result(raw_datum, extraction_filename, batch_result)
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

  def self.process_result(raw_datum, filename, batch_result)
    encoded_filename = ActiveSupport::Multibyte::Unicode.normalize(filename)
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
      filename = datum[:filename]
      raw_datum = RawDatum.new(
        project: project,
        shape: SHAPES.first,
        data: File.open(datum[:path])
      )
      raw_datum.data_file_name = filename
      if raw_datum.save
        batch_result[:success] << filename
      else
        batch_result[:error] << filename
      end
    end
    batch_result
  end

  def size?
    File.size? self.data.path
  end
end
