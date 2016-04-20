require 'rails_helper'

RSpec.describe "services/index", type: :view do
  before(:each) do
    assign(:services, [
      Service.create!(
        :roll => 2,
        :description => "Description",
        :capability => 3,
        :url => "Url",
        :title => "Title",
        :version => "Version"
      ),
      Service.create!(
        :roll => 2,
        :description => "Description",
        :capability => 3,
        :url => "Url",
        :title => "Title",
        :version => "Version"
      )
    ])
  end

  it "renders a list of services" do
    render
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => "Url".to_s, :count => 2
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "Version".to_s, :count => 2
  end
end
