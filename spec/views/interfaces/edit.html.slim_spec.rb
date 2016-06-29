require 'rails_helper'

RSpec.describe "interfaces/edit", type: :view do
  before(:each) do
    @interface = assign(:interface, Interface.create!())
  end

  it "renders the edit interface form" do
    render

    assert_select "form[action=?][method=?]", interface_path(@interface), "post" do
    end
  end
end
