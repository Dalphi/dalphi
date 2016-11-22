require 'rails_helper'

RSpec.describe 'Service destroy', type: :request do
  before(:each) do
    @project = FactoryGirl.create(:project)
    @service = FactoryGirl.create(:service)
    sign_in(@project.admin)
  end

  it 'destroys an service' do
    expect(Service.count).to eq(1)

    delete service_path(@service),
           params: {
             service: {
               id: @service.id
             }
           }

    expect(response.header['Location'].gsub(/\?.*/, '')).to eq(services_url)
    expect(Service.count).to eq(0)
  end
end
