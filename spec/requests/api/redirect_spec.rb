require 'rails_helper'

RSpec.describe "Redirection", type: :request do
  it 'redirects to the latest API version' do
    get '/api'
    expect(response).to redirect_to('/api/v1')
  end
end
