require 'rails_helper'

RSpec.describe 'Service create', type: :request do
  before(:each) do
    @project = FactoryGirl.create(:project)
    sign_in(@project.admin)
  end

  it 'creates a service' do
    expect(Service.count).to eq(0)

    post services_path,
         params: {
           service: {
             title: 'Testtitle',
             version: '1.0',
             description: 'test service description',
             role: 'iterate',
             problem_id: 'ner',
             url: 'http://localhost:3001',
             interface_types: %w(test_type another_test_type)
           }
         }

    expect(response.header['Location'].gsub(/\?.*/, '')).to eq(services_url)
    expect(Service.count).to eq(1)

    service = Service.first
    expect(service.title).to eq('Testtitle')
    expect(service.version).to eq('1.0')
    expect(service.description).to eq('test service description')
    expect(service.role).to eq('iterate')
    expect(service.problem_id).to eq('ner')
    expect(service.url).to eq('http://localhost:3001')
    expect(service.interface_types.sort).to eq(%w(test_type another_test_type).sort)
  end
end
