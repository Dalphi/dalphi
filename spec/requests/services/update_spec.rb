require 'rails_helper'

RSpec.describe 'Service update', type: :request do
  before(:each) do
    @project = FactoryGirl.create(:project)
    @service = FactoryGirl.create(:service)
    sign_in(@project.admin)
  end

  it 'updates a service with valid data' do
    expect(Service.count).to eq(1)

    put service_path(@service),
        params: {
          service: {
            id: @service.id,
            title: 'Testtitle',
            version: '1.0',
            description: 'test service description',
            role: 'iterate',
            problem_id: 'ner',
            url: 'http://localhost:3001',
            interface_types: @service.interface_types.map(&:id)
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
    expect(service.interface_types.map(&:id).sort).to eq(@service.interface_types.map(&:id).sort)
  end

  it 'rejects an update invalid data' do
    expect(Service.count).to eq(1)

    put service_path(@service),
        params: {
          service: {
            id: @service.id,
            title: '',
            version: '1.0',
            description: 'test service description',
            role: 'iterate',
            url: 'http://',
            interface_types: []
          }
        }

    expect(Service.count).to eq(1)
    service = Service.first
    expect(service).to eq(@service)
  end
end
