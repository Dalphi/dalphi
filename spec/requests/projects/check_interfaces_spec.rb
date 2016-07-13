require 'rails_helper'

RSpec.describe "Problem identifier check", type: :request do
  before(:each) do
    @project = FactoryGirl.create(:project)
    sign_in(@project.user)
  end

  it 'shows an empty hash for no selected interfaces' do
    @project.interfaces = []
    @project.save!

    get check_interfaces_path(@project), xhr: true
    expect(response).to be_success

    json = JSON.parse(response.body)
    expect(json).to eq(
      { 'selectedInterfaces' => {} }
    )
  end

  it "shows selected interfaces' titles grouped by type" do
    text_nominal_interface = FactoryGirl.create(:interface,
                                                  title: 'interface 1',
                                                  interface_type: 'text_nominal')
    text_not_so_nominal_interface = FactoryGirl.create(:interface,
                                                       title: 'interface 3',
                                                       interface_type: 'text_not_so_nominal')

    @project.interfaces = [text_nominal_interface]
    @project.save!

    get check_interfaces_path(@project), xhr: true
    expect(response).to be_success

    json = JSON.parse(response.body)
    expect(json).to eq(
      {
        'selectedInterfaces' => {
          'text_nominal' => text_nominal_interface.title
        }
      }
    )

    @project.interfaces = [
      text_nominal_interface,
      text_not_so_nominal_interface
    ]
    @project.save!

    get check_interfaces_path(@project), xhr: true
    expect(response).to be_success

    json = JSON.parse(response.body)
    expect(json).to eq(
      {
        'selectedInterfaces' => {
          'text_nominal' => text_nominal_interface.title,
          'text_not_so_nominal' => text_not_so_nominal_interface.title
        }
      }
    )
  end
end
