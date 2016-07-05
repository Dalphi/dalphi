require 'rails_helper'

RSpec.describe "RawData", type: :request do
  before(:each) do
    @raw_datum = FactoryGirl.create(:raw_datum)
    sign_in(@raw_datum.project.user)
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
         'data_file_name' => 'lorem.txt',
         'data_content_type' => 'text/plain',
         'data_file_size' => 1302,
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
end
