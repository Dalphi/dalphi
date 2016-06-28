require 'rails_helper'

RSpec.describe "RawData API", type: :request do
  it 'shows raw data' do
    raw_datum = FactoryGirl.create(:raw_datum)
    sign_in(raw_datum.project.user)

    get "/projects/#{raw_datum.project.id}/raw_data", xhr: true
    expect(response).to be_success

    json = JSON.parse(response.body)
    expect(json).to eq(
      [
        {
         'id' => 1,
         'shape' => 'text',
         'created_at' => json_datetime(raw_datum.created_at),
         'updated_at' => json_datetime(raw_datum.updated_at),
         'data_file_name' => 'lorem.txt',
         'data_content_type' => 'text/plain',
         'data_file_size' => 1302,
         'data_updated_at' => json_datetime(raw_datum.data_updated_at),
         'project_id' => 1,
         'filename' => 'file.md'
        }
      ]
    )
  end
end
