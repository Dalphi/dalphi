require 'rails_helper'

RSpec.describe 'Project create', type: :request do
  before(:each) do
    @project = FactoryGirl.build(:project)
    sign_in(@project.admin)
  end

  it 'creates a project with valid data' do
    expect(Project.count).to eq(0)

    post projects_path,
         params: {
           project: {
             title: 'brand new stuff',
             description: 'new project to be created'
           }
         }

    expect(Project.count).to eq(1)
    project = Project.first
    expect(project.title).to eq('brand new stuff')
    expect(project.description).to eq('new project to be created')
  end

  it 'does not create a project with invalid data' do
    expect(Project.count).to eq(0)

    post projects_path,
         params: {
           project: {
             description: 'new project to be created without mandatory title'
           }
         }

    expect(Project.count).to eq(0)
  end
end
