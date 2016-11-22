require 'feature_test_helper'
include Warden::Test::Helpers
WebMock.allow_net_connect!

feature 'Project selection from projects index view' do
  before(:each) do
    @project = FactoryGirl.create(:project_with_annotator)
  end

  describe 'having an admin logged in' do
    before(:each) do
      login_as(@project.admin, scope: :admin)
    end

    scenario 'list the present projects' do
      visit projects_path
      expect(current_path).to eq(projects_path)
      expect(page).to have_content(@project.title)
      expect(page).to have_content(@project.description)
    end

    scenario 'click on the present project' do
      visit projects_path
      click_on @project.title
      expect(current_path).to eq(project_path(@project))
    end
  end

  describe 'having an annotator logged in' do
    before(:each) do
      login_as(@project.annotators.first, scope: :annotator)
    end

    scenario 'list the present projects' do
      visit projects_path
      expect(current_path).to eq(projects_path)
      expect(page).to have_content(@project.title)
      expect(page).to have_content(@project.description)
    end

    scenario 'click on the present project' do
      visit projects_path
      click_on @project.title
      expect(current_path).to eq(project_path(@project))
    end
  end
end
