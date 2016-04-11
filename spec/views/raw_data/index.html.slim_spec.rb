require 'rails_helper'

RSpec.describe "raw_data/index", :type => :view do
  before(:each) do
    assign(:raw_data, [
      RawDatum.create!(
        :shape => "Shape"
      ),
      RawDatum.create!(
        :shape => "Shape"
      )
    ])
  end

  it "renders a list of raw_data" do
    render
    assert_select "tr>td", :text => "Shape".to_s, :count => 2
  end
end
