require 'rails_helper'

RSpec.describe AnnotationDocument, type: :model do
  before(:each) do
    @annotation_document = FactoryGirl.build(:annotation_document)
  end

  it 'should have a valid factory' do
    expect(@annotation_document).to be_valid
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
  end

  describe 'type' do
  end

  describe 'options' do
  end

  describe 'content' do
  end

  describe 'label' do
  end
end
