require 'rails_helper'

RSpec.configure do |c|
  c.include ServiceHelper
end

RSpec.describe Service, type: :model do
  before(:each) do
    @iterate_service = FactoryGirl.build(:iterate_service)
    @ml_service = FactoryGirl.build(:machine_learning_service)
    @merge_service = FactoryGirl.build(:merge_service)
  end

  it 'should have a valid factory' do
    expect(@ml_service).to be_valid
    expect(@iterate_service).to be_valid
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

    it 'can be iterate as integer 0' do
      role_is_valid @iterate_service, 0, 0
    end

    it 'can be merge as integer 1' do
      role_is_valid @merge_service, 1, 1
    end

    it 'can be machine_learning as integer 2' do
      role_is_valid @ml_service, 2, 2
    end

    it 'can be string iterate' do
      role_is_valid @iterate_service, 'iterate_service', 0
    end

    it 'can be string merge' do
      @merge_service.interface_types = []
      role_is_valid @merge_service, 'merge_service', 1
    end

    it 'can be string machine_learning' do
      @merge_service.interface_types = []
      role_is_valid @ml_service, 'machine_learning_service', 2
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
    it { should have_and_belong_to_many(:interface_types) }

    it 'can be empty for machine learning services' do
      @ml_service.interface_types.clear
      expect(@ml_service).to be_valid
    end

    it 'cannot have one or more elements for machine learning service' do
      interface_type_1 = FactoryGirl.create(:interface_type, name: 'fancy_interface')
      @ml_service.interface_types << interface_type_1
      expect(@ml_service).to be_invalid


      interface_type_2 = FactoryGirl.create(:interface_type, name: 'regular_interface')
      @ml_service.interface_types  << interface_type_2
      expect(@ml_service).to be_invalid
    end

    it 'can be empty for merge services' do
      @merge_service.interface_types.clear
      expect(@merge_service).to be_valid
    end

    it 'cannot have one or more elements for merge service' do
      interface_type_1 = FactoryGirl.create(:interface_type, name: 'fancy_interface')
      @merge_service.interface_types << interface_type_1
      expect(@merge_service).to be_invalid


      interface_type_2 = FactoryGirl.create(:interface_type, name: 'regular_interface')
      @merge_service.interface_types << interface_type_2
      expect(@merge_service).to be_invalid
    end

    it 'cannot be empty for iterate services' do
      @iterate_service.interface_types.clear
      expect(@iterate_service).to be_invalid
    end

    it 'can have one element for iterate service' do
      @iterate_service.interface_types << FactoryGirl.create(:interface_type,
                                                            name: 'fancy_interface')
      expect(@iterate_service).to be_valid
    end

    it 'can have multiple elements for iterate service' do
      @iterate_service.interface_types << FactoryGirl.create(:interface_type,
                                                             name: 'fancy_interface')
      @iterate_service.interface_types << FactoryGirl.create(:interface_type,
                                                             name: 'regular_interface')
      expect(@iterate_service).to be_valid
    end
  end
end
