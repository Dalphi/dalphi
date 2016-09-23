require 'rails_helper'

RSpec.describe "Connectivity check", type: :request do
  before(:each) do
    @service = FactoryGirl.create(:merge_service)
  end

  it 'should have a valid factory' do
    expect(@service).to be_valid
  end

  it 'shows service connectivity status' do
    raw_datum = FactoryGirl.create(:raw_datum)
    sign_in(raw_datum.project.admin)

    get check_connectivity_path(@service), xhr: true
    expect(response).to be_success

    json = JSON.parse(response.body)
    expect(json).to eq({ 'serviceIsAvailable' => true })
  end
end
