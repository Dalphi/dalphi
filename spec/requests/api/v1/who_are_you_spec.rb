require 'rails_helper'

RSpec.describe "WhoAreYou API", type: :request do
  it 'sends an identifying hash' do
    get '/api/v1'
    expect(response).to be_success
    json = response.body
    expect(json).to eq(
      {
        role: 'webapp',
        title: 'Dalphi',
        description: 'The Ruby on Rails Dalphi webapp ' \
                     'for user interaction and service intercommunication',
        problem_id: 'ner',
        version: '1.0'
      }.to_json
    )
  end

  it 'sends the interface_type for active learning services' do
    get 'http://localhost:3001'
    expect(response).to be_success
    json = response.body
    expect(json).to eq(
      {
        title: 'Test Active Learning Service',
        version: '1.0',
        description: 'An active learning dummy service that just implements the Who Are You API',
        role: 'active_learning',
        problem_id: 'ner',
        interface_type: 'text_nominal'
      }.to_json
    )
  end

  it 'sends the interface_type for bootstrap services' do
    get 'http://localhost:3002'
    expect(response).to be_success
    json = response.body
    expect(json).to eq(
      {
        title: 'Test Bootstrap Service',
        version: '1.0',
        description: 'A bootstrap dummy service that just implements the Who Are You API',
        role: 'bootstrap',
        problem_id: 'ner',
        interface_type: 'text_nominal'
      }.to_json
    )
  end
end
