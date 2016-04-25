require 'rails_helper'

RSpec.describe Service, type: :model do
  before(:each) do
    @al_service = FactoryGirl.build(:service_active_learning)
    @ml_service = FactoryGirl.build(:service_machine_learning)
    @bootstrap_service = FactoryGirl.build(:service_bootstrap)
  end

  it 'should have a valid factory' do
    expect(@al_service).to be_valid
    expect(@ml_service).to be_valid
    expect(@bootstrap_service).to be_valid
  end

  describe 'roll' do
    it 'can be nil' do
      @@al_service.roll = nil
      expect(@@al_service).to be_valid
    end

    it 'can be empty string' do
      @@al_service.roll = ''
      expect(@@al_service).to be_valid
    end

    it 'can consist only of whitespace' do
      @@al_service.roll = '  '
      expect(@@al_service).to be_valid
    end

    it 'should be valid' do
      @@al_service.roll = 'A valid roll'
      expect(@@al_service).to be_valid
    end
  end

  describe 'description' do
    it 'can be nil' do
      @@al_service.description = nil
      expect(@@al_service).to be_valid
    end

    it 'can be empty string' do
      @@al_service.description = ''
      expect(@@al_service).to be_valid
    end

    it 'can consist only of whitespace' do
      @@al_service.description = '  '
      expect(@@al_service).to be_valid
    end

    it 'should be valid' do
      @@al_service.description = 'A valid description'
      expect(@@al_service).to be_valid
    end
  end

  describe 'title' do
    it 'should not be nil' do
      @@al_service.title = nil
      expect(@@al_service).to be_invalid
    end

    it 'should not be empty string' do
      @@al_service.title = ''
      expect(@@al_service).to be_invalid
    end

    it 'should not consist only of whitespace' do
      @@al_service.title = '  '
      expect(@@al_service).to be_invalid
    end

    it 'should be valid' do
      @@al_service.title = 'A valid title'
      expect(@@al_service).to be_valid
    end
  end
end
