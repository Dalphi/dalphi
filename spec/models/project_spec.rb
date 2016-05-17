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

  describe 'active_learning_service' do
    it 'can be nil' do
      @project.active_learning_service = nil
      expect(@project).to be_valid
    end

    it 'can be a valid AL service' do
      service = FactoryGirl.create(:service_active_learning)
      @project.active_learning_service = service
      expect(@project).to be_valid
    end

    it 'can not be an invalid AL service' do
      service = FactoryGirl.create(:service_bootstrap)
      @project.active_learning_service = service
      expect(@project).to be_invalid
    end
  end

  describe 'bootstrap_service' do
    it 'can be nil' do
      @project.bootstrap_service = nil
      expect(@project).to be_valid
    end

    it 'can be a valid Bootstrap service' do
      service = FactoryGirl.create(:service_bootstrap)
      @project.bootstrap_service = service
      expect(@project).to be_valid
    end

    it 'can not be an invalid Bootstrap service' do
      service = FactoryGirl.create(:service_machine_learning)
      @project.bootstrap_service = service
      expect(@project).to be_invalid
    end
  end

  describe 'machine_learning_service' do
    it 'can be nil' do
      @project.machine_learning_service = nil
      expect(@project).to be_valid
    end

    it 'can be a valid machine learning service' do
      service = FactoryGirl.create(:service_machine_learning)
      @project.machine_learning_service = service
      expect(@project).to be_valid
    end

    it 'can not be an invalid machine learning service' do
      service = FactoryGirl.create(:service_active_learning)
      @project.machine_learning_service = service
      expect(@project).to be_invalid
    end
  end

  it { should have_many(:raw_data).dependent(:destroy) }

  it { should belong_to(:user) }
end
