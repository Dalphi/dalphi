require 'feature_test_helper'
include Warden::Test::Helpers
WebMock.allow_net_connect!

feature 'Project selection from projects index view' do
  before(:each) do
    @project = FactoryGirl.create(:project_with_annotator)
  end

  describe 'having an admin logged in.' do
    before(:each) do
      login_as(@project.admin, scope: :admin)
    end

    scenario 'Listing the present projects.' do
      visit projects_path
      expect(current_path).to eq(projects_path)
      expect(page).to have_content(@project.title)
      expect(page).to have_content(@project.description)
    end

    scenario 'Visiting the project\'s show view after clicking on a listed project.' do
      visit projects_path
      click_on @project.title
      expect(current_path).to eq(project_path(@project))
    end
  end

  describe 'having an annotator logged in.' do
    before(:each) do
      login_as(@project.annotators.first, scope: :annotator)
    end

    scenario 'Listing the present projects' do
      visit projects_path
      expect(current_path).to eq(projects_path)
      expect(page).to have_content(@project.title)
      expect(page).to have_content(@project.description)
    end

    describe 'Visiting the annotation view after clicking on a listed project having' do
      scenario 'no annotation documents present.' do
        visit projects_path
        @project.raw_data = []
        @project.save!

        click_on @project.title
        expect(current_path).to eq(project_annotate(@project))
      end

      scenario 'annotation documents present.' do
        visit projects_path
        annotation_document = FactoryGirl.create(:annotation_document_with_different_admin)
        @project.raw_data = [annotation_document.raw_datum]

        click_on @project.title
        expect(current_path).to eq(project_annotate_document(@project, annotation_document))
      end
    end
  end
end
