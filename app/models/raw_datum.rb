class RawDatum < ApplicationRecord
  SHAPES = %w(text)

  belongs_to :project
  has_attached_file :data

  validates :shape,
    presence: true,
    inclusion: { in: SHAPES }

  validates :data,
    attachment_presence: true

  validates_attachment :data,
    content_type: {
      content_type: [
        'text/plain',
        'text/markdown',
        'text/html',
        'text/rtf',
        'application/zip'
      ]
    }

  def self.zip_to_data(zip)
    temp_dir = Dir.mktmpdir
    begin
      batch_result = { success: [], error: [] }
      batch_result = process_zip_archive zip, temp_dir, batch_result
    ensure
      FileUtils.remove_entry temp_dir
    end
    return batch_result
  end


  def self.process_zip_archive(zip, temp_dir, batch_result)
    require 'zip'
    Zip::File.open(zip) do |zipfile|
      zipfile.each do |file|
        file_name = file.name
        extracted_file = "#{temp_dir}/#{file_name}"
        zipfile.extract(file, extracted_file)
        raw_datum = RawDatum.new(
          shape: SHAPES.first,
          data: File.open(extracted_file)
        )
        if raw_datum.save
          batch_result[:success] << file_name
        else
          batch_result[:error] << file_name
        end
      end
    end
    batch_result
  end
end
