require 'rails_helper'

RSpec.configure do |c|
  c.include ServiceHelper
end

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

  describe 'role' do
    it 'may not be nil' do
      @al_service.role = nil
      expect(@al_service).to be_invalid
    end

    it 'may not be empty string' do
      @al_service.role = ''
      expect(@al_service).to be_invalid
    end

    it 'can be active_learning as integer 0' do
      role_is_valid @al_service, 0, 0
    end

    it 'can be bootstrap as integer 1' do
      role_is_valid @al_service, 1, 1
    end

    it 'can be machine_learning as integer 2' do
      role_is_valid @al_service, 2, 2
    end

    it 'can be string active_learning' do
      role_is_valid @al_service, 'active_learning', 0
    end

    it 'can be string bootstrap' do
      role_is_valid @al_service, 'bootstrap', 1
    end

    it 'can be string machine_learning' do
      role_is_valid @al_service, 'machine_learning', 2
    end
  end

  describe 'description' do
    it 'can be nil' do
      @al_service.description = nil
      expect(@al_service).to be_valid
    end

    it 'can be an empty string' do
      @al_service.description = ''
      expect(@al_service).to be_valid
    end

    it 'can consist only of whitespace' do
      @al_service.description = '  '
      expect(@al_service).to be_valid
    end

    it 'can be a valid description' do
      @al_service.description = 'A valid description'
      expect(@al_service).to be_valid
    end
  end

  describe 'problem_id' do
    it 'may not be nil' do
      @al_service.problem_id = nil
      expect(@al_service).to be_invalid
    end

    it 'may not be empty string' do
      @al_service.problem_id = ''
      expect(@al_service).to be_invalid
    end

    it 'can be active_learning as integer 0' do
      problem_id_is_valid @al_service, 0, 0
    end

    it 'can be string active_learning' do
      problem_id_is_valid @al_service, 'ner', 0
    end
  end

  describe 'url' do
    it 'may not be nil' do
      @al_service.url = nil
      expect(@al_service).to be_invalid
    end

    it 'may not be empty' do
      @al_service.url = ''
      expect(@al_service).to be_invalid
    end

    it 'may not only consist of protocol identifier' do
      @al_service.url = 'http://'
      expect(@al_service).to be_invalid
    end

    it 'may not only consist of protocol identifier' do
      @al_service.url = 'https://'
      expect(@al_service).to be_invalid
    end

    it 'should be at least 4 characters long' do
      @al_service.url = 'http://g.co'
      expect(@al_service).to be_valid
    end

    it 'can be a valid URL' do
      @al_service.url = 'http://www.3antworten.de'
      expect(@al_service).to be_valid
    end

    it 'can be a valid URL' do
      @al_service.url = 'http://www.3antworten.com/'
      expect(@al_service).to be_valid
    end

    it 'can be a valid url' do
      @al_service.url = 'http://www.3antworten.de/#contact'
      expect(@al_service).to be_valid
    end

    it 'can be a valid url' do
      @al_service.url = 'http://petstore.swagger.io/'
      expect(@al_service).to be_valid
    end

    it 'can be a valid url' do
      @al_service.url = 'http://petstore.swagger.io/v2/swagger.json'
      expect(@al_service).to be_valid
    end

    # the following are locally possible but unreliable with Travis CI
    # it 'can be a valid local active_learning service dummy' do
    #   spawn_service_dummy('active_learning', 3101)
    #   @al_service.url = 'http://localhost:3101'
    #   expect(@al_service).to be_valid
    # end
    #
    # it 'can be a valid local bootstrap service dummy' do
    #   spawn_service_dummy('bootstrap', 3102)
    #   @al_service.url = 'http://localhost:3102'
    #   expect(@al_service).to be_valid
    # end
    #
    # it 'can be a valid local machine_learning service dummy' do
    #   spawn_service_dummy('machine_learning', 3103)
    #   @al_service.url = 'http://localhost:3103'
    #   expect(@al_service).to be_valid
    # end
  end

  describe 'title' do
    it 'should not be nil' do
      @al_service.title = nil
      expect(@al_service).to be_invalid
    end

    it 'should not be empty string' do
      @al_service.title = ''
      expect(@al_service).to be_invalid
    end

    it 'should not consist only of whitespace' do
      @al_service.title = '  '
      expect(@al_service).to be_invalid
    end

    it 'should be valid' do
      @al_service.title = 'A valid title'
      expect(@al_service).to be_valid
    end
  end

  describe 'version' do
    it 'should not be nil' do
      @al_service.version = nil
      expect(@al_service).to be_invalid
    end

    it 'should not be empty string' do
      @al_service.version = ''
      expect(@al_service).to be_invalid
    end

    it 'should not consist only of whitespace' do
      @al_service.version = '  '
      expect(@al_service).to be_invalid
    end

    it 'can be a valid string' do
      @al_service.version = 'v8.1.2-beta3'
      expect(@al_service).to be_valid
    end

    it 'can be a valid string' do
      @al_service.version = '8.1.2'
      expect(@al_service).to be_valid
    end

    it 'can be a valid string' do
      @al_service.version = '8'
      expect(@al_service).to be_valid
    end
  end
end
