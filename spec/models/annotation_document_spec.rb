require 'rails_helper'

RSpec.describe AnnotationDocument, type: :model do
  before(:each) do
    @annotation_document = FactoryGirl.build(:annotation_document)
    @annotation_document_with_different_user = FactoryGirl.build(:annotation_document_with_different_user,
                                                                 interface_type: @annotation_document.interface_type)
  end

  it 'should have a valid factory' do
    expect(@annotation_document).to be_valid
    expect(@annotation_document_with_different_user).to be_valid
  end

  describe 'raw_datum' do
    it 'should be present' do
      @annotation_document.raw_datum = nil
      expect(@annotation_document).to be_invalid
    end

    it { should belong_to(:raw_datum) }
  end

  describe 'project' do
    it { should belong_to(:project) }
  end

  describe 'interface_type' do
    it 'may not be nil' do
      @annotation_document.interface_type = nil
      expect(@annotation_document).to be_invalid
    end

    it { should belong_to(:interface_type) }
  end

  describe 'payload' do
    it 'should not be nil' do
      @annotation_document.payload = nil
      expect(@annotation_document).to be_invalid
    end

    it 'should not be empty' do
      @annotation_document.payload = ''
      expect(@annotation_document).to be_invalid
      @annotation_document.payload = '   '
      expect(@annotation_document).to be_invalid
    end

    describe 'should be unique within one project and' do
      it 'should not be assigned twice' do
        common_project = @annotation_document_with_different_user.raw_datum.project
        test_string = 'The company Implisense GmbH in Berlin.'

        @annotation_document_with_different_user.payload = test_string
        @annotation_document_with_different_user.save!

        @annotation_document.payload = test_string
        @annotation_document.raw_datum.project = common_project
        expect(@annotation_document).to be_invalid
      end

      it 'can be different' do
        common_project = @annotation_document_with_different_user.raw_datum.project
        test_string_1 = 'The company Implisense GmbH in Berlin.'
        test_string_2 = 'The company 3antworten UG in Berlin.'

        @annotation_document_with_different_user.payload = test_string_1
        @annotation_document_with_different_user.save!

        @annotation_document.payload = test_string_2
        @annotation_document.raw_datum.project = common_project
        expect(@annotation_document).to be_valid
      end

      it 'can be the same in different projects' do
        project_1 = @annotation_document.raw_datum.project
        project_2 = FactoryGirl.create(:another_project)
        test_string = 'The company Implisense GmbH in Berlin.'

        @annotation_document_with_different_user.payload = test_string
        @annotation_document_with_different_user.raw_datum.project = project_1
        @annotation_document_with_different_user.save!

        @annotation_document.payload = test_string
        @annotation_document.raw_datum.project = project_2
        expect(@annotation_document).to be_valid
      end
    end
  end

  describe 'rank' do
    it 'can be nil' do
      @annotation_document.rank = nil
      expect(@annotation_document).to be_valid
    end

    it 'should not be negative' do
      @annotation_document.rank = -1
      expect(@annotation_document).to be_invalid
    end

    it 'can be zero' do
      @annotation_document.rank = 0
      expect(@annotation_document).to be_valid
    end

    it 'can an integer greater than zero' do
      5.times do |i|
        @annotation_document.rank = i + 1
        expect(@annotation_document).to be_valid
      end
    end
  end

  describe 'skipped' do
    it 'can be nil' do
      @annotation_document.skipped = nil
      expect(@annotation_document).to be_valid
    end

    it 'should be a boolean' do
      [true, false].each do |bool|
        @annotation_document.skipped = bool
        expect(@annotation_document).to be_valid
      end
    end
  end

  describe 'requested_at' do
    it 'can be nil' do
      @annotation_document.requested_at = nil
      expect(@annotation_document).to be_valid
    end

    it 'cannot be in the future' do
      @annotation_document.requested_at = Time.zone.now + 1.minute
      expect(@annotation_document).to be_invalid
    end

    it 'can be now' do
      @annotation_document.requested_at = Time.zone.now
      expect(@annotation_document).to be_valid
    end

    it 'can be in the past' do
      @annotation_document.requested_at = Time.zone.now - 1.month
      expect(@annotation_document).to be_valid
    end
  end
end
