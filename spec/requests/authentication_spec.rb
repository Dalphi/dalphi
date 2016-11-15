require 'rails_helper'

RSpec.describe "Authentication", type: :request do
  it 'blocks unauthenticated access' do
    get '/projects'
    expect(response).to redirect_to(new_annotator_session_path)
  end

  it 'allows authenticated admins access' do
    admin = FactoryGirl.create(:admin)
    sign_in(admin)
    get '/projects'
    expect(response).to be_success
  end

  it 'allows authenticated annotators access' do
    annotator = FactoryGirl.create(:annotator)
    sign_in(annotator)
    get '/projects'
    expect(response).to be_success
  end
end
