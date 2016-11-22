require 'rails_helper'

RSpec.describe 'Interface refresh', type: :request do
  before(:each) do
    @project = FactoryGirl.create(:project)
    @interface = FactoryGirl.create(:interface)
    sign_in(@project.admin)
  end

  it 'refreshs an interface' do
    expect(Interface.count).to eq(1)

    post refresh_interface_path(@interface),
         params: {
           interface: {
             id: @interface.id
           }
         }

    expect(response.header['Location'].gsub(/\?.*/, '')).to eq(edit_interface_url(@interface))
    expect(Interface.count).to eq(1)
    interface = Interface.first
    expect(interface).to eq(@interface)
  end
end
