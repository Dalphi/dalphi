require 'rails_helper'

RSpec.describe 'Service refresh', type: :request do
  before(:each) do
    service_url = 'http://example.com/iterate'

    stub_request(:get, service_url)
      .to_return(
        status: 200,
        body: {
          "role" => "iterate_service",
          "title" => "NER Example",
          "description" => "Iterate Service for dummy NER service",
          "version" => "0.1",
          "problem_id" => "ner",
          "interface_types" => [],
          "url" => "http://example.com/iterate"
        }.to_json
      )

    @project = FactoryGirl.create(:project)
    @service = FactoryGirl.create(:service, url: service_url)
    sign_in(@project.admin)
  end

  it 'updates a service with valid data' do
    expect(Service.count).to eq(1)

    stub_request(:get, @service.url)
      .to_return(
        status: 200,
        body: {
          "role" => "iterate_service",
          "title" => "NER Example new",
          "description" => "Iterate Service for dummy NER service to be refreshed",
          "version" => "0.2",
          "problem_id" => "ner",
          "interface_types" => @service.interface_types.map(&:name),
          "url" => "http://example.com/iterate"
        }.to_json
      )

    patch refresh_service_path(@service),
          params: {
            service: {
              id: @service.id
            }
          }

    expect(response.header['Location']).to eq(edit_service_url(@service))
    expect(Service.count).to eq(1)

    service = Service.first
    expect(service.title).to eq('NER Example new')
    expect(service.version).to eq('0.2')
    expect(service.description).to eq('Iterate Service for dummy NER service to be refreshed')
    expect(service.role).to eq('iterate_service')
    expect(service.problem_id).to eq('ner')
    expect(service.url).to eq('http://example.com/iterate')
    expect(service.interface_types.map(&:id).sort).to eq(@service.interface_types.map(&:id).sort)
  end

  it 'rejects an update invalid data' do
    expect(Service.count).to eq(1)

    stub_request(:get, @service.url)
      .to_return(
        status: 200,
        body: {
          "role" => "iterate_service",
          "title" => "NER Example new",
          "description" => "Iterate Service for dummy NER service to be refreshed",
          "version" => "0.2",
          "problem_id" => "ner",
          "interface_types" => @service.interface_types.map(&:name),
          "url" => "http://example.com/iterate"
        }.to_json
      )

    patch refresh_service_path(@service),
          params: {
            service: {
              id: @service.id
            }
          }

    expect(Service.count).to eq(1)
    service = Service.first
    expect(service).to eq(@service)
  end
end
