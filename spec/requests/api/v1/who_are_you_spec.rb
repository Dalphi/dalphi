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
        url: root_url,
        version: '1.0'
      }.to_json
    )
  end
end
