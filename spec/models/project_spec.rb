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
      service = FactoryGirl.create(:active_learning_service)
      @project.active_learning_service = service
      expect(@project).to be_valid
    end

    it 'can not be an invalid AL service' do
      service = FactoryGirl.create(:bootstrap_service)
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
      service = FactoryGirl.create(:bootstrap_service)
      @project.bootstrap_service = service
      expect(@project).to be_valid
    end

    it 'can not be an invalid Bootstrap service' do
      service = FactoryGirl.create(:machine_learning_service)
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
      service = FactoryGirl.create(:machine_learning_service)
      @project.machine_learning_service = service
      expect(@project).to be_valid
    end

    it 'can not be an invalid machine learning service' do
      service = FactoryGirl.create(:active_learning_service)
      @project.machine_learning_service = service
      expect(@project).to be_invalid
    end
  end

  describe 'merge_service' do
    it 'can be nil' do
      @project.merge_service = nil
      expect(@project).to be_valid
    end

    it 'can be a valid merge service' do
      service = FactoryGirl.create(:merge_service)
      @project.merge_service = service
      expect(@project).to be_valid
    end

    it 'can not be an invalid merge service' do
      service = FactoryGirl.create(:active_learning_service)
      @project.merge_service = service
      expect(@project).to be_invalid
    end
  end

  describe 'associated_problem_identifiers' do
    it 'should return an empty list if no service is associated' do
      @project.active_learning_service = nil
      @project.bootstrap_service = nil
      @project.machine_learning_service = nil
      @project.merge_service = nil

      expect(@project.associated_problem_identifiers).to eq([])
    end

    it 'should return a singleton if all associated services handle the same problem identifier' do
      @project.active_learning_service = FactoryGirl.create(:active_learning_service, problem_id: 'NER')
      @project.bootstrap_service = FactoryGirl.create(:bootstrap_service, problem_id: 'NER')
      @project.machine_learning_service = FactoryGirl.create(:machine_learning_service, problem_id: 'NER')
      @project.merge_service = FactoryGirl.create(:merge_service, problem_id: 'NER')

      expect(@project.associated_problem_identifiers).to eq(['NER'])
    end

    it 'should return a set of different problem identifiers if associated services handle them' do
      @project.active_learning_service = FactoryGirl.create(:active_learning_service, problem_id: 'UltraNER')
      @project.bootstrap_service = FactoryGirl.create(:bootstrap_service, problem_id: 'HyperNER')
      @project.machine_learning_service = FactoryGirl.create(:machine_learning_service, problem_id: 'MegaNER')
      @project.merge_service = FactoryGirl.create(:merge_service, problem_id: 'NER')

      expect(@project.associated_problem_identifiers.sort).to eq(['UltraNER', 'HyperNER', 'MegaNER', 'NER'].sort)
    end
  end

  it { should have_many(:raw_data).dependent(:destroy) }

  it { should belong_to(:user) }
end
