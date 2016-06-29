require 'rails_helper'

RSpec.describe "interfaces/show", type: :view do
  before(:each) do
    @interface = assign(:interface, Interface.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
