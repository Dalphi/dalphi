require 'rails_helper'

RSpec.describe "Problem identifier check", type: :request do
  before(:each) do
    @project = FactoryGirl.create(:project)
    sign_in(@project.user)
  end

  it 'shows an empty hash for no necessary interface types' do
    @project.iterate_service = nil
    @project.interfaces = []
    @project.save!

    get check_interfaces_path(@project), xhr: true
    expect(response).to be_success

    json = JSON.parse(response.body)
    expect(json).to eq(
      { 'selectedInterfaces' => {} }
    )
  end

  it 'shows a hash with empty keys for no selected interface types' do
    interface_type = FactoryGirl.create(:interface_type_text_nominal)
    @project.iterate_service = FactoryGirl.create(:iterate_service,
                                                  interface_types: [interface_type])
    @project.interfaces = []
    @project.save!

    get check_interfaces_path(@project), xhr: true
    expect(response).to be_success

    json = JSON.parse(response.body)
    expect(json).to eq(
      {
        'selectedInterfaces' => {
          'text_nominal' => nil
        }
      }
    )
  end

  it 'shows a hash with empty keys for no selected interface types' do
    interface_type_1 = FactoryGirl.create(:interface_type_text_nominal)
    interface_type_2 = FactoryGirl.create(:interface_type_other)
    @project.iterate_service = FactoryGirl.create(:iterate_service,
                                                  interface_types: [
                                                    interface_type_1,
                                                    interface_type_2
                                                  ])
    @project.interfaces = []
    @project.save!

    get check_interfaces_path(@project), xhr: true
    expect(response).to be_success

    json = JSON.parse(response.body)
    expect(json).to eq(
      {
        'selectedInterfaces' => {
          'text_nominal' => nil,
          'other_interface_type' => nil
        }
      }
    )
  end

  it "shows selected interfaces' titles grouped by type" do
    interface_type = FactoryGirl.create(:interface_type_text_nominal)
    @project.iterate_service = FactoryGirl.create(:iterate_service,
                                                  interface_types: [interface_type])
    text_nominal_interface = FactoryGirl.create(:interface,
                                                title: 'interface 1',
                                                interface_type: interface_type)

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
  end

  it "shows selected interfaces' titles grouped by type" do
    interface_type_1 = FactoryGirl.create(:interface_type_text_nominal)
    interface_type_2 = FactoryGirl.create(:interface_type_other)
    @project.iterate_service = FactoryGirl.create(:iterate_service,
                                                  interface_types: [
                                                    interface_type_1,
                                                    interface_type_2
                                                  ])
    text_nominal_interface = FactoryGirl.create(:interface,
                                                title: 'interface 1',
                                                interface_type: interface_type_1)
    text_not_so_nominal_interface = FactoryGirl.create(:interface,
                                                       title: 'interface 3',
                                                       interface_type: interface_type_2)

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
          'other_interface_type' => text_not_so_nominal_interface.title
        }
      }
    )
  end
end
