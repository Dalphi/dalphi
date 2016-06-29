require 'rails_helper'

RSpec.describe "Project boostrap", type: :request do
  it 'should not connect services if no service available' do
    Service.destroy_all
    project = FactoryGirl.build(:project)
    sign_in(project.user)

    post projects_path,
         params: {
           project: {
             :id => nil,
             :title => "Test project",
             :description => "A test project for testing purposes only.",
             :created_at => nil,
             :updated_at => nil,
             :user_id => 1,
             :active_learning_service_id => nil,
             :bootstrap_service_id => nil,
             :machine_learning_service_id => nil,
             :merge_service_id => nil
           }
         }
    expect(response).to redirect_to(project_raw_data_path(project_id: 1))

    project = Project.first
    expect(project.active_learning_service).to eq(nil)
    expect(project.bootstrap_service).to eq(nil)
    expect(project.machine_learning_service).to eq(nil)
    expect(project.merge_service).to eq(nil)
  end

  it 'should connect services from different types if exactly one service per type exists' do
    Service.destroy_all
    project = FactoryGirl.build(:project)
    sign_in(project.user)
    active_learning_service = FactoryGirl.create(:active_learning_service)
    bootstrap_service = FactoryGirl.create(:bootstrap_service)

    post projects_path,
         params: {
           project: {
             :id => nil,
             :title => "Test project",
             :description => "A test project for testing purposes only.",
             :created_at => nil,
             :updated_at => nil,
             :user_id => 1,
             :active_learning_service_id => nil,
             :bootstrap_service_id => nil,
             :machine_learning_service_id => nil,
             :merge_service_id => nil
           }
         }

    project = Project.first
    expect(response).to redirect_to(project_raw_data_path(project_id: 1))
    expect(project.active_learning_service).to eq(active_learning_service)
    expect(project.bootstrap_service).to eq(bootstrap_service)
    expect(project.machine_learning_service).to eq(nil)
    expect(project.merge_service).to eq(nil)
  end

  it 'should only connect thoses services where exactly one service per type exists' do
    Service.destroy_all
    project = FactoryGirl.build(:project)
    sign_in(project.user)
    FactoryGirl.create(:active_learning_service)
    FactoryGirl.create(:active_learning_service, url: 'http://yet-another-dalphi-service.com')
    bootstrap_service = FactoryGirl.create(:bootstrap_service)

    post projects_path,
         params: {
           project: {
             :id => nil,
             :title => "Test project",
             :description => "A test project for testing purposes only.",
             :created_at => nil,
             :updated_at => nil,
             :user_id => 1,
             :active_learning_service_id => nil,
             :bootstrap_service_id => nil,
             :machine_learning_service_id => nil,
             :merge_service_id => nil
           }
         }

    project = Project.first
    expect(response).to redirect_to(project_raw_data_path(project_id: 1))
    expect(project.active_learning_service).to eq(nil)
    expect(project.bootstrap_service).to eq(bootstrap_service)
    expect(project.machine_learning_service).to eq(nil)
    expect(project.merge_service).to eq(nil)
  end
end
