require 'rails_helper'

RSpec.describe RawDatum, type: :model do
  before(:each) do
    @raw_datum = FactoryGirl.build(:raw_datum)
  end

  it 'should have a valid factory' do
    expect(@raw_datum).to be_valid
  end

  describe 'filename' do
    it 'should not be nil' do
      @raw_datum.filename = nil
      expect(@raw_datum).to be_invalid
    end

    it 'should not be empty string' do
      @raw_datum.filename = ''
      expect(@raw_datum).to be_invalid
    end

    it 'should not consist only of whitespace' do
      @raw_datum.filename = '  '
      expect(@raw_datum).to be_invalid
    end

    it 'can be a valid filename' do
      @raw_datum.filename = 'file.md'
      expect(@raw_datum).to be_valid
    end

    it 'can be a path with directories' do
      @raw_datum.filename = 'directory/file.md'
      expect(@raw_datum).to be_valid
    end

    it 'should be unique in the scope of projects and override existing raw_data' do
      expect(RawDatum.all.size).to eq(0)
      @raw_datum.filename = 'file1.md'
      @raw_datum.save!
      expect(RawDatum.all.size).to eq(1)
      another_raw_datum = FactoryGirl.build(:raw_datum,
        filename: 'file2.md',
        project: @raw_datum.project
      )
      another_raw_datum.save!
      expect(RawDatum.all.size).to eq(2)
    end

    it 'should be unique in the scope of projects and override existing raw_data' do
      expect(RawDatum.all.size).to eq(0)
      @raw_datum.filename = 'file1.md'
      @raw_datum.save!
      old_id = @raw_datum.id
      expect(RawDatum.all.size).to eq(1)
      another_raw_datum = FactoryGirl.build(:raw_datum,
        filename: 'file1.md',
        project: @raw_datum.project
      )
      another_raw_datum.save!
      expect(RawDatum.all.size).to eq(1)
      expect(old_id != another_raw_datum.id)
    end
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
      file_path = Rails.root.join('spec/fixtures/text/lorem.txt')
      @raw_datum.data = File.new(file_path)
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
      file_path = Rails.root.join('spec/fixtures/zip/valid.zip')
      batch_result = RawDatum.zip_to_data @raw_datum.project,
                                          file_path
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
      file_path = Rails.root.join('spec/fixtures/zip/partially-valid.zip')
      batch_result = RawDatum.zip_to_data @raw_datum.project,
                                          file_path
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
      file_path = Rails.root.join('spec/fixtures/zip/invalid.zip')
      batch_result = RawDatum.zip_to_data @raw_datum.project,
                                          file_path
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
      file_path = Rails.root.join('spec/fixtures/zip/subdirectory1.zip')
      batch_result = RawDatum.zip_to_data @raw_datum.project,
                                          file_path
      expect(batch_result).to eq(
        {
          success: ['root_file.md', 'subdir/file.md'],
          error: []
        }
      )
      expect(RawDatum.all.count).to eq(2)
    end

    it 'can batch process a zip archive with subdirectories' do
      expect(RawDatum.all.count).to eq(0)
      file_path = Rails.root.join('spec/fixtures/zip/subdirectory2.zip')
      batch_result = RawDatum.zip_to_data @raw_datum.project,
                                          file_path
      expect(batch_result).to eq(
        {
          success: ['valid1.md', 'subdir/valid2.md'],
          error: ['invalid1.bin', 'subdir/invalid2.bin']
        }
      )
      expect(RawDatum.all.count).to eq(2)
    end

    it 'can batch process a zip archive with Mac encoded file names' do
      expect(RawDatum.all.count).to eq(0)
      file_path = Rails.root.join('spec/fixtures/zip/mac_encoding.zip')
      batch_result = RawDatum.zip_to_data @raw_datum.project,
                                          file_path
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
      file_path = Rails.root.join('spec/fixtures/zip/linux_encoding.zip')
      batch_result = RawDatum.zip_to_data @raw_datum.project,
                                          file_path
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
      file_path_1 = Rails.root.join('spec/fixtures/text/valid1.md')
      file_path_2 = Rails.root.join('spec/fixtures/text/valid2.md')
      data = [
        { filename: 'valid1.md', path: file_path_1 },
        { filename: 'valid2.md', path: file_path_2 }
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
      file_path_1 = Rails.root.join('spec/fixtures/text/valid.md')
      file_path_2 = Rails.root.join('spec/fixtures/text/invalid.bin')
      data = [
        { filename: 'valid.md', path: file_path_1 },
        { filename: 'invalid.bin', path: file_path_2 }
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
      file_path_1 = Rails.root.join('spec/fixtures/text/invalid1.bin')
      file_path_2 = Rails.root.join('spec/fixtures/text/invalid2.bin')
      data = [
        { filename: 'invalid1.bin', path: file_path_1 },
        { filename: 'invalid2.bin', path: file_path_2 },
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
      file_path = Rails.root.join('spec/fixtures/text/lorem.txt')
      @raw_datum.data = File.new(file_path)
      expect(@raw_datum).to be_valid
    end

    it 'should be a text file if shape is text' do
      @raw_datum.shape = 'text'
      file_path = Rails.root.join('spec/fixtures/text/ipsum.txt')
      @raw_datum.data = File.new(file_path)
      expect(@raw_datum).to be_valid
    end

    it 'can be a json file if shape is text' do
      @raw_datum.shape = 'text'
      file_path = Rails.root.join('spec/fixtures/text/data.json')
      @raw_datum.data = File.new(file_path)
      expect(@raw_datum).to be_valid
    end

    it 'should be a text file if shape is text' do
      @raw_datum.shape = 'text'
      file_path = Rails.root.join('spec/fixtures/image/implisense-logo.png')
      @raw_datum.data = File.new(file_path)
      expect(@raw_datum).to be_invalid
    end

    it 'should not be a text file if shape not text' do
      @raw_datum.shape = 'image'
      file_path = Rails.root.join('spec/fixtures/text/lorem.txt')
      @raw_datum.data = File.new(file_path)
      expect(@raw_datum).to be_invalid
    end

    it 'should not be a text file if shape not text' do
      @raw_datum.shape = 'sound'
      file_path = Rails.root.join('spec/fixtures/text/lorem.txt')
      @raw_datum.data = File.new(file_path)
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
