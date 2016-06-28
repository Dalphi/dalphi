require 'rails_helper'

RSpec.describe "Project boostrap", type: :request do
  it "sends raw data to a bootstrap service" do
    raw_datum = FactoryGirl.create(:raw_datum)
    project = raw_datum.project
    project.bootstrap_service = FactoryGirl.create(:bootstrap_service)
    project.save!
    sign_in(project.user)

    get project_bootstrap_path(project)
    expect(response.header['Location'].gsub(/\?.*/, '')).to eq(project_url(project))
  end
end
