require 'rails_helper'

RSpec.configure do |c|
  c.include ServiceHelper
end

RSpec.describe Service, type: :model do
  before(:each) do
    @bootstrap_service = FactoryGirl.build(:bootstrap_service)
    @ml_service = FactoryGirl.build(:machine_learning_service)
    @merge_service = FactoryGirl.build(:merge_service)
  end

  it 'should have a valid factory' do
    expect(@ml_service).to be_valid
    expect(@bootstrap_service).to be_valid
    expect(@merge_service).to be_valid
  end

  describe 'role' do
    it 'may not be nil' do
      @merge_service.role = nil
      expect(@merge_service).to be_invalid
    end

    it 'may not be empty string' do
      @merge_service.role = ''
      expect(@merge_service).to be_invalid
    end

    it 'can be bootstrap as integer 0' do
      role_is_valid @bootstrap_service, 0, 0
    end

    it 'can be merge as integer 1' do
      role_is_valid @merge_service, 1, 1
    end

    it 'can be machine_learning as integer 2' do
      role_is_valid @ml_service, 2, 2
    end

    it 'can be string bootstrap' do
      role_is_valid @bootstrap_service, 'bootstrap', 0
    end

    it 'can be string merge' do
      @merge_service.interface_types = []
      role_is_valid @merge_service, 'merge', 1
    end

    it 'can be string machine_learning' do
      @merge_service.interface_types = []
      role_is_valid @ml_service, 'machine_learning', 2
    end
  end

  describe 'description' do
    it 'can be nil' do
      @merge_service.description = nil
      expect(@merge_service).to be_valid
    end

    it 'can be an empty string' do
      @merge_service.description = ''
      expect(@merge_service).to be_valid
    end

    it 'can consist only of whitespace' do
      @merge_service.description = '  '
      expect(@merge_service).to be_valid
    end

    it 'can be a valid description' do
      @merge_service.description = 'A valid description'
      expect(@merge_service).to be_valid
    end
  end

  describe 'problem_id' do
    it 'may not be nil' do
      @merge_service.problem_id = nil
      expect(@merge_service).to be_invalid
    end

    it 'may not be empty string' do
      @merge_service.problem_id = ''
      expect(@merge_service).to be_invalid
    end

    it 'may not only consist of whitespace' do
      @merge_service.problem_id = '  '
      expect(@merge_service).to be_invalid
    end

    it 'can consist of letters' do
      @merge_service.problem_id = 'abc'
      expect(@merge_service).to be_valid
    end

    it 'can consist of letters' do
      @merge_service.problem_id = 'aBcD'
      expect(@merge_service).to be_valid
    end

    it 'can consist of numbers' do
      @merge_service.problem_id = '1234'
      expect(@merge_service).to be_valid
    end

    it 'can consist of hypens dots, hyphens and underscores' do
      @merge_service.problem_id = '.-_'
      expect(@merge_service).to be_valid
    end

    it 'can consist of a combination of letters, numbers, dots, hyphens and underscores' do
      @merge_service.problem_id = 'a1b-h.c3a_Add52'
      expect(@merge_service).to be_valid
    end

    it 'can be any string (\w) with hyphens' do
      alphabet = [('a'..'z'), ('A'..'Z'), (0..9)].map { |i| i.to_a }.flatten.concat(['_', '-', '.'])
      (0..10).each do
        @merge_service.problem_id = (0...15).map { alphabet[rand(alphabet.length)] }.join
        expect(@merge_service).to be_valid
      end
    end

    it 'should not contain special characters besides _ - .' do
      @merge_service.problem_id = 'qwerty!@#$%^&*()_'
      expect(@merge_service).to be_invalid
    end
  end

  describe 'url' do
    it 'may not be nil' do
      @merge_service.url = nil
      expect(@merge_service).to be_invalid
    end

    it 'may not be empty' do
      @merge_service.url = ''
      expect(@merge_service).to be_invalid
    end

    it 'may not only consist of protocol identifier' do
      @merge_service.url = 'http://'
      expect(@merge_service).to be_invalid
    end

    it 'may not only consist of protocol identifier' do
      @merge_service.url = 'https://'
      expect(@merge_service).to be_invalid
    end

    it 'should be at least 4 characters long' do
      @merge_service.url = 'http://g.co'
      expect(@merge_service).to be_valid
    end

    it 'can be a valid URL' do
      @merge_service.url = 'http://www.3antworten.de'
      expect(@merge_service).to be_valid
    end

    it 'can be a valid URL' do
      @merge_service.url = 'http://www.3antworten.com/'
      expect(@merge_service).to be_valid
    end

    it 'can be a valid url' do
      @merge_service.url = 'http://www.3antworten.de/#contact'
      expect(@merge_service).to be_valid
    end

    it 'can be a valid url' do
      @merge_service.url = 'http://petstore.swagger.io/'
      expect(@merge_service).to be_valid
    end

    it 'can be a valid url' do
      @merge_service.url = 'http://petstore.swagger.io/v2/swagger.json'
      expect(@merge_service).to be_valid
    end

    it 'should be unique, so that two services with different URLs can exist' do
      expect(Service.all.size).to eq(0)
      @merge_service.url = 'http://localhost:3000'
      @merge_service.save!
      expect(Service.all.size).to eq(1)
      another_merge_service = FactoryGirl.build(
        :merge_service,
        url: 'http://localhost:3001'
      )
      expect(another_merge_service).to be_valid
      another_merge_service.save!
      expect(Service.all.size).to eq(2)
    end

    it 'should be unique, so that two services with the same URL cannot exist' do
      @merge_service.url = 'http://localhost:3000'
      @merge_service.save!
      another_merge_service = FactoryGirl.build(
        :merge_service,
        url: @merge_service.url
      )
      expect(another_merge_service).to be_invalid
    end

    it 'cannot be an unreachable resource' do
      @merge_service.url = 'http://example.com/unreachable/resource'
      expect(@merge_service).to be_invalid
    end
  end

  describe 'title' do
    it 'should not be nil' do
      @merge_service.title = nil
      expect(@merge_service).to be_invalid
    end

    it 'should not be empty string' do
      @merge_service.title = ''
      expect(@merge_service).to be_invalid
    end

    it 'should not consist only of whitespace' do
      @merge_service.title = '  '
      expect(@merge_service).to be_invalid
    end

    it 'should be valid' do
      @merge_service.title = 'A valid title'
      expect(@merge_service).to be_valid
    end
  end

  describe 'version' do
    it 'should not be nil' do
      @merge_service.version = nil
      expect(@merge_service).to be_invalid
    end

    it 'should not be empty string' do
      @merge_service.version = ''
      expect(@merge_service).to be_invalid
    end

    it 'should not consist only of whitespace' do
      @merge_service.version = '  '
      expect(@merge_service).to be_invalid
    end

    it 'can be a valid string' do
      @merge_service.version = 'v8.1.2-beta3'
      expect(@merge_service).to be_valid
    end

    it 'can be a valid string' do
      @merge_service.version = '8.1.2'
      expect(@merge_service).to be_valid
    end

    it 'can be a valid string' do
      @merge_service.version = '8'
      expect(@merge_service).to be_valid
    end
  end

  describe 'interface types' do
    it 'can be empty for machine learning services' do
      @ml_service.interface_types = []
      expect(@ml_service).to be_valid
    end

    it 'cannot have one or more elements for machine learning service' do
      @ml_service.interface_types = %w(fancy_interface)
      expect(@ml_service).to be_invalid

      @ml_service.interface_types = %w(fancy_interface regular_interface)
      expect(@ml_service).to be_invalid
    end

    it 'can be empty for merge services' do
      @merge_service.interface_types = []
      expect(@merge_service).to be_valid
    end

    it 'cannot have one or more elements for merge service' do
      @merge_service.interface_types = %w(fancy_interface)
      expect(@merge_service).to be_invalid

      @merge_service.interface_types = %w(fancy_interface regular_interface)
      expect(@merge_service).to be_invalid
    end

    it 'cannot be empty for bootstrap services' do
      @bootstrap_service.interface_types = []
      expect(@bootstrap_service).to be_invalid
    end

    it 'can have one element for bootstrap service' do
      @bootstrap_service.interface_types = %w(fancy_interface)
      expect(@bootstrap_service).to be_valid
    end

    it 'can have multiple elements for bootstrap service' do
      @bootstrap_service.interface_types = %w(fancy_interface regular_interface)
      expect(@bootstrap_service).to be_valid
    end
  end
end
