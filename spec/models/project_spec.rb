require 'rails_helper'

RSpec.describe Project, type: :model do
  before(:each) do
    @project = FactoryGirl.build(:project)
  end

  it 'should have a valid factory' do
    expect(@project).to be_valid
  end

  describe 'title' do
    it 'should not be nil' do
      @project.title = nil
      expect(@project).to be_invalid
    end

    it 'should not be empty string' do
      @project.title = ''
      expect(@project).to be_invalid
    end

    it 'should not consist only of whitespace' do
      @project.title = '  '
      expect(@project).to be_invalid
    end

    it 'should be valid' do
      @project.title = 'A valid title'
      expect(@project).to be_valid
    end
  end

  describe 'description' do
    it 'can be nil' do
      @project.description = nil
      expect(@project).to be_valid
    end

    it 'can be empty string' do
      @project.description = ''
      expect(@project).to be_valid
    end

    it 'can consist only of whitespace' do
      @project.description = '  '
      expect(@project).to be_valid
    end

    it 'should be valid' do
      @project.description = 'A valid description'
      expect(@project).to be_valid
    end
  end

  it { should have_many(:raw_data).dependent(:destroy) }

  it { should belong_to(:user) }
end
