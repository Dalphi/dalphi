require 'rails_helper'

RSpec.describe "raw_data/show", :type => :view do
  before(:each) do
    @raw_datum = assign(:raw_datum, RawDatum.create!(
      :shape => "Shape"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Shape/)
  end
end
