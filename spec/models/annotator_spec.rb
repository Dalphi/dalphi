require 'rails_helper'

RSpec.describe Annotator, type: :model do
  before(:each) do
    @annotator = FactoryGirl.create(:annotator)
  end

  it 'should have a valid factory' do
    expect(@annotator).to be_valid
  end

  it { should validate_presence_of(:name) }

  it { should have_many(:annotation_documents) }

  describe 'projects' do
    it 'should have and belong to many' do
      should have_and_belong_to_many(:projects)
    end

    it 'can be extended by assigning an annotator' do
      @project = FactoryGirl.create :project
      expect(@annotator.projects.count).to eq(0)

      @annotator.projects << @project
      @annotator.save!
      @project.reload

      expect(@annotator.projects.count).to eq(1)
      expect(@project.annotators).to include(@annotator)
    end

    it 'can be reduced by unassigning an annotator' do
      @project = FactoryGirl.create :project
      @annotator.projects << @project
      @annotator.save!
      expect(@annotator.projects.count).to eq(1)

      @annotator.projects.delete(@project)
      @annotator.save!
      @project.reload

      expect(@annotator.projects.count).to eq(0)
      expect(@project.annotators).not_to include(@annotator)
    end
  end
end
