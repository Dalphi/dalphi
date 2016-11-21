require 'feature_test_helper'
include Warden::Test::Helpers
WebMock.allow_net_connect!

feature 'Project selection from projects index view' do
  before(:each) do
    @project = FactoryGirl.create(:project)
    login_as(@project.admin, scope: :admin)
  end

  describe 'having an admin logged in', js: true do
    scenario 'list the present project' do
      visit projects_path
      expect(page).to have_content(@project.title)
      expect(page).to have_content(@project.description)
    end

    scenario 'click on the present project' do
      visit projects_path
      # click_on @project.title
      page.find(:css, ".container.projects tbody tr:first-of-type").click()
      expect(current_url).to eq(project_path(@project))
      # expect(page).to have_content(@project.title)
      # expect(page).to have_content(@project.description)
    end
  end
end
