require 'rails_helper'

RSpec.describe 'RawData', type: :request do
  before(:each) do
    @raw_datum = FactoryGirl.create(:raw_datum)
    sign_in(@raw_datum.project.admin)
  end

  it 'shows raw data' do
    get "/projects/#{@raw_datum.project.id}/raw_data",
        xhr: true
    expect(response).to be_success

    json = JSON.parse(response.body)
    expect(json).to eq(
      [
        {
         'id' => 1,
         'shape' => 'text',
         'created_at' => json_datetime(@raw_datum.created_at),
         'updated_at' => json_datetime(@raw_datum.updated_at),
         'data_file_name' => '2000-06-08-com.handelsblatt.www.in9r34todujsm7zd5sk4ba0n.txt',
         'data_content_type' => 'text/plain',
         'data_file_size' => 5665,
         'data_updated_at' => json_datetime(@raw_datum.data_updated_at),
         'project_id' => 1,
         'filename' => 'file.md'
        }
      ]
    )
  end

  it 'accepts empty data' do
    post project_raw_data_path(@raw_datum.project),
         params: {
           raw_datum: {
             shape: 'text',
             data: []
           }
         }
    expect(response).to be_success
  end

  it 'accepts binary garbage' do
    post project_raw_data_path(@raw_datum.project),
         params: {
           raw_datum: {
             shape: 'text',
             data: [fixture_file_upload('spec/fixtures/text/invalid.bin', 'application/octet-stream')]
           }
         }
    expect(response).to be_success
  end

  it 'sends a zip archive containing all raw data' do
    project = @raw_datum.project
    project.raw_data = [
      @raw_datum,
      FactoryGirl.create(:raw_datum_with_different_data, project: project)
    ]
    project.save!

    begin
      file = Tempfile.new('raw-data-zip')
      Zip::OutputStream.open(file) { |zos| }
      Zip::File.open(file.path, Zip::File::CREATE) do |zipfile|
        project.raw_data.each do |raw_datum|
          zipfile.add(raw_datum.filename, raw_datum.data.path)
        end
      end

      get project_raw_data_path(project, format: :zip)

      expect(response).to be_success
      expect(response.body).to eq(File.read(file.path))
    ensure
      file.close
      file.unlink
    end
  end
end
