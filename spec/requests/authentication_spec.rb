require 'rails_helper'

RSpec.describe "Authentication", type: :request do
  it "blocks unauthenticated access" do
    get '/projects'
    expect(response).to redirect_to(new_user_session_path)
  end

  it "allows authenticated access" do
    user = FactoryGirl.create(:user)
    sign_in(user)
    get '/projects'
    expect(response).to be_success
  end
end
