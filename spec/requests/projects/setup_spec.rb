require 'rails_helper'

RSpec.describe 'Project setup', type: :request do
  before(:each) do
    Service.destroy_all
    project = FactoryGirl.build(:project)
    @current_user = project.user
    sign_in(@current_user)
  end

  describe 'new project & project creation' do
    it 'should render the new project form', focus: true do
      get new_project_path
      expect(response).to render_template(:new)
    end

    it 'should create a new project if no other projects, no services, no data and no interfaces are present' do
      Project.destroy_all
      Service.destroy_all
      RawDatum.destroy_all
      Interface.destroy_all

      post projects_path,
           params: {
             project: {
               :id => nil,
               :title => 'Test project',
               :description => 'A test project for testing purposes only.',
               :user_id => @current_user,
               :active_learning_service_id => nil,
               :bootstrap_service_id => nil,
               :machine_learning_service_id => nil,
               :merge_service_id => nil
             }
           }

      expect(Project.count).to eq(1)
      expect(response).to redirect_to(project_raw_data_path(project_id: 1))

      project = Project.first
      expect(project.title).to eq('Test project')
      expect(project.description).to eq('A test project for testing purposes only.')
      expect(project.user).to eq(@current_user)
    end
  end

  describe 'service preselection' do
    it 'should not connect services if no service available' do
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
end
