require 'rails_helper'

RSpec.describe "interfaces/new", type: :view do
  before(:each) do
    assign(:interface, Interface.new())
  end

  it "renders new interface form" do
    render

    assert_select "form[action=?][method=?]", interfaces_path, "post" do
    end
  end
end
