require 'rails_helper'

RSpec.describe "Service registration", type: :request do
  before(:each) do
    Service.destroy_all
    user = FactoryGirl.build(:user)
    sign_in(user)
  end

  it 'should register interface types' do
    expect(Service.count).to eq(0)
    post services_path,
         params: {
           service: {
             role: 'bootstrap',
             description: 'A bootstrap dummy service that just implements the Who Are You API',
             problem_id: 'ner',
             url: 'http://localhost:3001',
             title: 'Test Bootstrap Service',
             version: '1.0',
             interface_types: %w(text_nominal)
           }
         }
    expect(Service.count).to eq(1)

    bootstrap_service = Service.first
    expect(bootstrap_service.interface_types).to eq(%w(text_nominal))
  end

  it 'should fail to register a bootstrap service without any interface types' do
    expect(Service.count).to eq(0)
    post services_path,
         params: {
           service: {
             role: 'bootstrap',
             description: 'A bootstrap dummy service that just implements the Who Are You API',
             problem_id: 'ner',
             url: 'http://localhost:3001',
             title: 'Test Bootstrap Service',
             version: '1.0',
             interface_types: []
           }
         }
    expect(Service.count).to eq(0)
  end
end
