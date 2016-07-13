require "rails_helper"

RSpec.describe InterfacesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/interfaces").to route_to("interfaces#index")
    end

    it "routes to #new" do
      expect(:get => "/interfaces/new").to route_to("interfaces#new")
    end

    it "routes to #show" do
      expect(:get => "/interfaces/1").to route_to("interfaces#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/interfaces/1/edit").to route_to("interfaces#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/interfaces").to route_to("interfaces#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/interfaces/1").to route_to("interfaces#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/interfaces/1").to route_to("interfaces#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/interfaces/1").to route_to("interfaces#destroy", :id => "1")
    end

  end
end
