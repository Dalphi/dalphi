require 'rails_helper'

RSpec.describe "Problem identifier check", type: :request do
  before(:each) do
    @project = FactoryGirl.create(:project)
    sign_in(@project.user)
  end

  it 'shows an empty hash for no necessary interface types' do
    @project.active_learning_service = nil
    @project.bootstrap_service = nil
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
    @project.active_learning_service = FactoryGirl.create(:active_learning_service,
                                                          interface_types: %w(text_nominal))
    @project.bootstrap_service = nil
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
    @project.active_learning_service = FactoryGirl.create(:active_learning_service,
                                                          interface_types: %w(text_nominal))
    @project.bootstrap_service = FactoryGirl.create(:bootstrap_service,
                                                    interface_types: %w(text_nominal text_not_so_nominal))
    @project.interfaces = []
    @project.save!

    get check_interfaces_path(@project), xhr: true
    expect(response).to be_success

    json = JSON.parse(response.body)
    expect(json).to eq(
      {
        'selectedInterfaces' => {
          'text_nominal' => nil,
          'text_not_so_nominal' => nil
        }
      }
    )
  end

  it "shows selected interfaces' titles grouped by type" do
    @project.active_learning_service = FactoryGirl.create(:active_learning_service,
                                                          interface_types: %w(text_nominal))
    @project.bootstrap_service = FactoryGirl.create(:bootstrap_service,
                                                    interface_types: %w(text_nominal))
    text_nominal_interface = FactoryGirl.create(:interface,
                                                title: 'interface 1',
                                                interface_type: 'text_nominal')

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
    @project.active_learning_service = FactoryGirl.create(:active_learning_service,
                                                          interface_types: %w(text_nominal))
    @project.bootstrap_service = FactoryGirl.create(:bootstrap_service,
                                                    interface_types: %w(text_nominal text_not_so_nominal))
    text_nominal_interface = FactoryGirl.create(:interface,
                                                title: 'interface 1',
                                                interface_type: 'text_nominal')
    text_not_so_nominal_interface = FactoryGirl.create(:interface,
                                                       title: 'interface 3',
                                                       interface_type: 'text_not_so_nominal')

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
