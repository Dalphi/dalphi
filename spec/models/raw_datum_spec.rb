require 'rails_helper'

RSpec.describe RawDatum, :type => :model do
  before(:each) do
    @raw_datum = FactoryGirl.build(:raw_datum)
  end

  it 'should have a valid factory' do
    expect(@raw_datum).to be_valid
  end

  describe 'shape' do
    it 'should not be nil' do
      @raw_datum.shape = nil
      expect(@raw_datum).to be_invalid
    end

    it 'should not be empty string' do
      @raw_datum.shape = ''
      expect(@raw_datum).to be_invalid
    end

    it 'should not consist only of whitespace' do
      @raw_datum.shape = '  '
      expect(@raw_datum).to be_invalid
    end

    it 'should have a valid value: text' do
      @raw_datum.shape = 'text'
      @raw_datum.data = File.new("#{Rails.root}/spec/fixtures/text/lorem.txt")
      expect(@raw_datum).to be_valid
    end

    it 'should not have a value not defined in the SHAPES array' do
      @raw_datum.shape = 'M0ST unl1kely sh4pe n4me'
      expect(@raw_datum).to be_invalid
    end

    it 'can batch process a zip archive with valid files' do
      expect(RawDatum.all.count).to eq(0)
      batch_result = RawDatum::zip_to_data("#{Rails.root}/spec/fixtures/zip/valid.zip")
      expect(batch_result).to eq(
        {
          success: ['valid1.md', 'valid2.md'],
          error: []
        }
      )
      expect(RawDatum.all.count).to eq(2)
    end

    it 'can batch process a zip archive with partially valid files' do
      expect(RawDatum.all.count).to eq(0)
      batch_result = RawDatum::zip_to_data("#{Rails.root}/spec/fixtures/zip/partially-valid.zip")
      expect(batch_result).to eq(
        {
          success: ['valid.md'],
          error: ['invalid.bin']
        }
      )
      expect(RawDatum.all.count).to eq(1)
    end

    it 'can batch process a zip archive with partially valid files' do
      expect(RawDatum.all.count).to eq(0)
      batch_result = RawDatum::zip_to_data("#{Rails.root}/spec/fixtures/zip/invalid.zip")
      expect(batch_result).to eq(
        {
          success: [],
          error: ['invalid1.bin', 'invalid2.bin']
        }
      )
      expect(RawDatum.all.count).to eq(0)
    end
  end

  describe 'data' do
    it 'should not be nil' do
      @raw_datum.data = nil
      expect(@raw_datum).to be_invalid
    end

    it 'should be a text file if shape is text' do
      @raw_datum.shape = 'text'
      @raw_datum.data = File.new("#{Rails.root}/spec/fixtures/text/lorem.txt")
      expect(@raw_datum).to be_valid
    end

    it 'should be a text file if shape is text' do
      @raw_datum.shape = 'text'
      @raw_datum.data = File.new("#{Rails.root}/spec/fixtures/text/ipsum.txt")
      expect(@raw_datum).to be_valid
    end

    it 'should be a text file if shape is text' do
      @raw_datum.shape = 'text'
      @raw_datum.data = File.new("#{Rails.root}/spec/fixtures/image/implisense-logo.png")
      expect(@raw_datum).to be_invalid
    end

    it 'should not be a text file if shape not text' do
      @raw_datum.shape = 'image'
      @raw_datum.data = File.new("#{Rails.root}/spec/fixtures/text/lorem.txt")
      expect(@raw_datum).to be_invalid
    end

    it 'should not be a text file if shape not text' do
      @raw_datum.shape = 'sound'
      @raw_datum.data = File.new("#{Rails.root}/spec/fixtures/text/lorem.txt")
      expect(@raw_datum).to be_invalid
    end
  end

  it { should belong_to(:project) }
end
