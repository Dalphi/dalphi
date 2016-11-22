require 'rails_helper'

RSpec.describe 'Projectd destroy', type: :request do
  before(:each) do
    @project = FactoryGirl.create(:project)
    sign_in(@project.admin)
  end

  it 'destroys an project' do
    expect(Project.count).to eq(1)

    delete project_path(@project),
           params: {
             project: {
               id: @project.id
             }
           }

    expect(response.header['Location'].gsub(/\?.*/, '')).to eq(projects_url)
    expect(Project.count).to eq(0)
  end
end
