require 'rails_helper'

RSpec.describe "raw_data/edit", :type => :view do
  before(:each) do
    @raw_datum = assign(:raw_datum, RawDatum.create!(
      :shape => "MyString"
    ))
  end

  it "renders the edit raw_datum form" do
    render

    assert_select "form[action=?][method=?]", raw_datum_path(@raw_datum), "post" do

      assert_select "input#raw_datum_shape[name=?]", "raw_datum[shape]"
    end
  end
end
