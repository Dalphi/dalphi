require 'rails_helper'

RSpec.describe "Service API", type: :request do
  it 'shows service connectivity status' do
    raw_datum = FactoryGirl.create(:raw_datum)
    service = FactoryGirl.create(:active_learning_service)
    sign_in(raw_datum.project.user)

    get "/services/#{service.id}/connectivity", xhr: true
    expect(response).to be_success

    json = JSON.parse(response.body)
    expect(json).to eq(
      {
        'serviceIsAvailable' => {
          'address' => 'www.google.com',
          'port' => 80,
          'local_host' => nil,
          'local_port' => nil,
          'curr_http_version' => '1.1',
          'keep_alive_timeout' => 2,
          'last_communicated' => nil,
          'close_on_empty_response' => false,
          'socket' => nil,
          'started' => false,
          'open_timeout' => 60,
          'read_timeout' => 60,
          'continue_timeout' => nil,
          'debug_output' => nil,
          'proxy_from_env' => true,
          'proxy_uri' => nil,
          'proxy_address' => nil,
          'proxy_port' => nil,
          'proxy_user' => nil,
          'proxy_pass' => nil,
          'use_ssl' => false,
          'ssl_context' => nil,
          'ssl_session' => nil,
          'sspi_enabled' => false,
          'ca_file' => nil,
          'ca_path' => nil,
          'cert' => nil,
          'cert_store' => nil,
          'ciphers' => nil,
          'key' => nil,
          'ssl_timeout' => nil,
          'ssl_version' => nil,
          'verify_callback' => nil,
          'verify_depth' => nil,
          'verify_mode' => nil
        }
      }
    )
  end
end
