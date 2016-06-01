require 'rails_helper'

RSpec.describe AnnotationDocument, type: :model do
  before(:each) do
    @annotation_document = FactoryGirl.build(:annotation_document)
    @annotation_ducument_with_different_user = FactoryGirl.build(:annotation_ducument_with_different_user)
  end

  it 'should have a valid factory' do
    expect(@annotation_document).to be_valid
    expect(@annotation_ducument_with_different_user).to be_valid
  end

  describe 'chunk_offset' do
    it 'should not be nil' do
      @annotation_document.chunk_offset = nil
      expect(@annotation_document).to be_invalid
    end

    it 'should not be negative' do
      @annotation_document.chunk_offset = -1
      expect(@annotation_document).to be_invalid
    end

    it 'can not be greater than the byte size of the related raw_datum' do
      upper_limit = @annotation_document.raw_datum.size?
      @annotation_document.chunk_offset = upper_limit + 1
      expect(@annotation_document).to be_invalid
    end
  end

  describe 'raw_datum' do
    it 'should be present' do
      @annotation_document.raw_datum = nil
      expect(@annotation_document).to be_invalid
    end

    it { should belong_to(:raw_datum) }
  end

  describe 'type' do
    it 'may not be nil' do
      @annotation_document.type = nil
      expect(@annotation_document).to be_invalid
    end

    it 'may not be empty string' do
      @annotation_document.type = ''
      expect(@annotation_document).to be_invalid
    end

    it 'can be text_nominal as text string' do
      @annotation_document.type = 'text_nominal'
      expect(@annotation_document).to be_valid
    end

    it 'can be text_nominal as integer 0' do
      @annotation_document.type = 0
      expect(@annotation_document).to be_valid
    end
  end

  describe 'options' do
    it 'may not be nil' do
      @annotation_document.options = nil
      expect(@annotation_document).to be_invalid
    end

    it 'may not be an empty array' do
      @annotation_document.options = []
      expect(@annotation_document).to be_invalid
    end

    it 'should have more than one items' do
      @annotation_document.options = ['a option']
      expect(@annotation_document).to be_invalid
    end

    it 'should have at leat two items' do
      @annotation_document.options = ['a option', 'an other option']
      expect(@annotation_document).to be_valid
    end

    it 'type of options should be string' do
      @annotation_document.options = [42, 1337, 7]
      expect(@annotation_document).to be_invalid
    end
  end

  describe 'content' do
    it 'should not be nil' do
      @annotation_document.content = nil
      expect(@annotation_document).to be_invalid
    end

    describe 'is related to it\'s raw_datum\'s shape and' do
      it 'can be a text file if raw_data shape is text' do
        @annotation_document.raw_datum.shape = 'text'
        file_path = Rails.root.join('spec/fixtures/text/valid1.md')
        @annotation_document.content = File.new(file_path)
        expect(@annotation_document).to be_valid
      end

      it 'can be a text file if raw_data shape is text' do
        @annotation_document.raw_datum.shape = 'text'
        file_path = Rails.root.join('spec/fixtures/text/lorem_first_chunk.txt')
        @annotation_document.content = File.new(file_path)
        expect(@annotation_document).to be_valid
      end

      it 'can be a binary file if raw_data shape is binary' do
        pending('is implemented but raw_datum needs to support more than one shape')
        @annotation_document.raw_datum.shape = 'application'
        file_path = Rails.root.join('spec/fixtures/text/invalid.bin')
        @annotation_document.content = File.new(file_path)
        expect(@annotation_document).to be_valid
      end

      it 'can not be a text file if raw_data shape is binary' do
        pending('is implemented but raw_datum needs to support more than one shape')
        @annotation_document.raw_datum.shape = 'application'
        file_path = Rails.root.join('spec/fixtures/text/valid1.md')
        @annotation_document.content = File.new(file_path)
        expect(@annotation_document).to be_invalid
      end

      it 'can not be a binary file if raw_data shape is text' do
        @annotation_document.raw_datum.shape = 'text'
        file_path = Rails.root.join('spec/fixtures/text/invalid.bin')
        @annotation_document.content = File.new(file_path)
        expect(@annotation_document).to be_invalid
      end
    end

    describe 'should be unique within one project and' do
      it 'should not be assigned twice' do
        common_project = @annotation_ducument_with_different_user.raw_datum.project
        file_path = Rails.root.join('spec/fixtures/text/lorem_first_chunk.txt')

        @annotation_ducument_with_different_user.content = File.new(file_path)
        @annotation_ducument_with_different_user.save!

        @annotation_document.content = File.new(file_path)
        @annotation_document.raw_datum.project = common_project
        expect(@annotation_document).to be_invalid
      end

      it 'can be different' do
        common_project = @annotation_ducument_with_different_user.raw_datum.project
        file_path_1 = Rails.root.join('spec/fixtures/text/lorem_first_chunk.txt')
        file_path_2 = Rails.root.join('spec/fixtures/text/lorem_second_chunk.txt')

        @annotation_ducument_with_different_user.content = File.new(file_path_1)
        @annotation_ducument_with_different_user.save!

        @annotation_document.content = File.new(file_path_2)
        @annotation_document.raw_datum.project = common_project
        expect(@annotation_document).to be_valid
      end

      it 'can be the same in different projects' do
        project_1 = @annotation_document.raw_datum.project
        project_2 = FactoryGirl.create(:another_project)
        file_path = Rails.root.join('spec/fixtures/text/lorem_first_chunk.txt')

        @annotation_ducument_with_different_user.content = File.new(file_path)
        @annotation_ducument_with_different_user.raw_datum.project = project_1
        @annotation_ducument_with_different_user.save!

        @annotation_document.content = File.new(file_path)
        @annotation_document.raw_datum.project = project_2
        expect(@annotation_document).to be_valid
      end
    end
  end

  describe 'label' do
    it 'can be nil' do
      @annotation_document.label = nil
      expect(@annotation_document).to be_valid
    end

    it 'sould be an element of the options array' do
      options = @annotation_document.options

      @annotation_document.label = options.first
      expect(@annotation_document).to be_valid

      @annotation_document.label = options.last
      expect(@annotation_document).to be_valid
    end

    it 'can not be anything else but an element of the options array' do
      target_string = 'unlikely label'
      @annotation_document.options -= [target_string]
      @annotation_document.label = target_string
      expect(@annotation_document).to be_invalid
    end
  end
end
