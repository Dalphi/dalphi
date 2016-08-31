require 'rails_helper'

RSpec.describe 'Interface destroy', type: :request do
  before(:each) do
    @project = FactoryGirl.create(:project)
    @interface = FactoryGirl.create(:interface)
    sign_in(@project.user)
  end

  it 'destroys an interface' do
    expect(Interface.count).to eq(1)

    delete interface_path(@interface),
           params: {
             interface: {
               id: @interface.id
             }
           }

    expect(response.header['Location'].gsub(/\?.*/, '')).to eq(interfaces_url)
    expect(Interface.count).to eq(0)
  end
end
