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
  end

  describe 'zip_to_data' do
    it 'can batch process a zip archive with valid files' do
      expect(RawDatum.all.count).to eq(0)
      batch_result = RawDatum.zip_to_data @raw_datum.project,
                                          "#{Rails.root}/spec/fixtures/zip/valid.zip"
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
      batch_result = RawDatum.zip_to_data @raw_datum.project,
                                          "#{Rails.root}/spec/fixtures/zip/partially-valid.zip"
      expect(batch_result).to eq(
        {
          success: ['valid.md'],
          error: ['invalid.bin']
        }
      )
      expect(RawDatum.all.count).to eq(1)
    end

    it 'can batch process a zip archive with invalid files' do
      expect(RawDatum.all.count).to eq(0)
      batch_result = RawDatum.zip_to_data @raw_datum.project,
                                          "#{Rails.root}/spec/fixtures/zip/invalid.zip"
      expect(batch_result).to eq(
        {
          success: [],
          error: ['invalid1.bin', 'invalid2.bin']
        }
      )
      expect(RawDatum.all.count).to eq(0)
    end

    it 'can batch process a zip archive with subdirectories' do
      expect(RawDatum.all.count).to eq(0)
      batch_result = RawDatum.zip_to_data @raw_datum.project,
                                          "#{Rails.root}/spec/fixtures/zip/subdirectory1.zip"
      expect(batch_result).to eq(
        {
          success: ['root_file.md', 'subdir∕file.md'], # be aware that the slash is U+2215
          error: []
        }
      )
      expect(RawDatum.all.count).to eq(2)
    end

    it 'can batch process a zip archive with subdirectories' do
      expect(RawDatum.all.count).to eq(0)
      batch_result = RawDatum.zip_to_data @raw_datum.project,
                                          "#{Rails.root}/spec/fixtures/zip/subdirectory2.zip"
      expect(batch_result).to eq(
        {
          success: ['valid1.md', 'subdir∕valid2.md'], # be aware that the slash is U+2215
          error: ['invalid1.bin', 'subdir∕invalid2.bin'] # be aware that the slash is U+2215
        }
      )
      expect(RawDatum.all.count).to eq(2)
    end

    it 'can batch process a zip archive with Mac encoded file names' do
      expect(RawDatum.all.count).to eq(0)
      batch_result = RawDatum.zip_to_data @raw_datum.project,
                                          "#{Rails.root}/spec/fixtures/zip/mac_encoding.zip"
      expect(batch_result).to eq(
        {
          success: ['äöüß.md'],
          error: []
        }
      )
      expect(RawDatum.all.count).to eq(1)
    end

    it 'can batch process a zip archive with Linux encoded file names' do
      expect(RawDatum.all.count).to eq(0)
      batch_result = RawDatum.zip_to_data @raw_datum.project,
                                          "#{Rails.root}/spec/fixtures/zip/linux_encoding.zip"
      expect(batch_result).to eq(
        {
          success: ['äöüß.md'],
          error: []
        }
      )
      expect(RawDatum.all.count).to eq(1)
    end
  end

  describe 'batch_create' do
    it 'can batch process a set of valid files' do
      expect(RawDatum.all.count).to eq(0)
      data = [
        { filename: 'valid1.md', path: "#{Rails.root}/spec/fixtures/text/valid1.md" },
        { filename: 'valid2.md', path: "#{Rails.root}/spec/fixtures/text/valid2.md" }
      ]
      batch_result = RawDatum.batch_create @raw_datum.project,
                                           data
      expect(batch_result).to eq(
        {
          success: ['valid1.md', 'valid2.md'],
          error: []
        }
      )
      expect(RawDatum.all.count).to eq(2)
    end

    it 'can batch process a set of partially valid files' do
      expect(RawDatum.all.count).to eq(0)
      data = [
        { filename: 'valid.md', path: "#{Rails.root}/spec/fixtures/text/valid.md" },
        { filename: 'invalid.bin', path: "#{Rails.root}/spec/fixtures/text/invalid.bin" }
      ]
      batch_result = RawDatum.batch_create @raw_datum.project,
                                           data
      expect(batch_result).to eq(
        {
          success: ['valid.md'],
          error: ['invalid.bin']
        }
      )
      expect(RawDatum.all.count).to eq(1)
    end

    it 'can batch process a set of invalid files' do
      expect(RawDatum.all.count).to eq(0)
      data = [
        { filename: 'invalid1.bin', path: "#{Rails.root}/spec/fixtures/text/invalid1.bin" },
        { filename: 'invalid2.bin', path: "#{Rails.root}/spec/fixtures/text/invalid2.bin" },
      ]
      batch_result = RawDatum.batch_create @raw_datum.project,
                                           data
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

  describe 'project' do
    it 'should not be project-less' do
      @raw_datum.project = nil
      expect(@raw_datum).to be_invalid
    end

    it { should belong_to(:project) }
  end
end
