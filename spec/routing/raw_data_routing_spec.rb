require "rails_helper"

RSpec.describe RawDataController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/raw_data").to route_to("raw_data#index")
    end

    it "routes to #new" do
      expect(:get => "/raw_data/new").to route_to("raw_data#new")
    end

    it "routes to #show" do
      expect(:get => "/raw_data/1").to route_to("raw_data#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/raw_data/1/edit").to route_to("raw_data#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/raw_data").to route_to("raw_data#create")
    end

    it "routes to #update" do
      expect(:put => "/raw_data/1").to route_to("raw_data#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/raw_data/1").to route_to("raw_data#destroy", :id => "1")
    end

  end
end
