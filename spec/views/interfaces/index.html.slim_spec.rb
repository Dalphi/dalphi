require 'rails_helper'

RSpec.describe "interfaces/index", type: :view do
  before(:each) do
    assign(:interfaces, [
      Interface.create!(),
      Interface.create!()
    ])
  end

  it "renders a list of interfaces" do
    render
  end
end
