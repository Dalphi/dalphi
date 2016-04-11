require 'rails_helper'

RSpec.describe "raw_data/new", :type => :view do
  before(:each) do
    assign(:raw_datum, RawDatum.new(
      :shape => "MyString"
    ))
  end

  it "renders new raw_datum form" do
    render

    assert_select "form[action=?][method=?]", raw_data_path, "post" do

      assert_select "input#raw_datum_shape[name=?]", "raw_datum[shape]"
    end
  end
end
