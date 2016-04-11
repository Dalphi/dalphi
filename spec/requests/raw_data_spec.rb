require 'rails_helper'

RSpec.describe "RawData", :type => :request do
  describe "GET /raw_data" do
    it "works! (now write some real specs)" do
      get raw_data_path
      expect(response).to have_http_status(200)
    end
  end
end
