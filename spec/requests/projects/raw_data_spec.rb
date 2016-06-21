require 'rails_helper'

RSpec.describe "RawData API", type: :request do
  it 'shows raw data' do
    sign_in
    raw_datum = FactoryGirl.create(:raw_datum)
    get "/projects/#{raw_datum.project.id}/raw_data", format: :json
    ap response.body
    expect(response).to be_success
    json = JSON.parse(response.body)
    expect(json).to eq(
      {
        'id' => 1,
        'interface_type' => 'text_nominal',
        'payload' => "{\"label\":\"testlabel\",\"options\":[\"option1\",\"option2\"],\"content\":\"testcontent\"}",
        'rank' => nil,
        'raw_datum_id' => 1,
        'skipped' => nil
      }
    )
  end
end
