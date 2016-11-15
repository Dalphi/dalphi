require 'rails_helper'

RSpec.describe 'Project update', type: :request do
  before(:each) do
    @project = FactoryGirl.create(:project)
    sign_in(@project.admin)
  end

  it 'updates a project with valid data' do
    expect(Project.count).to eq(1)

    patch project_path(@project),
          params: {
            project: {
              title: 'most recently updated stuff',
              description: 'super up-to-date, you will not believe it!'
            }
          }

    expect(Project.count).to eq(1)
    project = Project.first
    expect(project.title).to eq('most recently updated stuff')
    expect(project.description).to eq('super up-to-date, you will not believe it!')
  end

  it 'does not create a project with invalid data' do
    expect(Project.count).to eq(1)

    patch project_path(@project),
          params: {
            project: {
              description: 'new project to be created without mandotory title'
            }
          }

    expect(Project.count).to eq(1)
    project = Project.first
    expect(project).to eq(@project)
  end
end
