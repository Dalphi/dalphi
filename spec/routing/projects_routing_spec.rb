require 'rails_helper'

RSpec.describe 'Projects Routing Spec', type: :routing do
  before(:each) do
    @project = FactoryGirl.create(:project)
  end

  describe 'Projects Controller' do
    it 'should route `projects/:id` to `projects#show` for entity :id' do
      project_id = @project.id.to_s
      expect(get: "projects/#{project_id}").to route_to(
        controller: 'projects',
        action: 'show',
        id: project_id
      )
    end
  end
end
