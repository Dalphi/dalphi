class RawDatum < ApplicationRecord
  MIME_TYPES = {
    text: [
      'text/plain',
      'text/markdown',
      'text/html',
      'text/rtf'
    ],
  }
  SHAPES = MIME_TYPES.keys.map(&:to_s)

  belongs_to :project
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
      content_type: MIME_TYPES.values.first
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
        filename = file.name
        zipfile.extract(file, "#{temp_dir}/#{filename}")
        raw_datum = RawDatum.new(
          project: project,
          shape: SHAPES.first,
          data: File.open("#{temp_dir}/#{filename}")
        )
        if raw_datum.save
          batch_result[:success] << filename
        else
          batch_result[:error] << filename
        end
      end
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
end
