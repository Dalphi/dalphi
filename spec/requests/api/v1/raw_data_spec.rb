require 'rails_helper'

RSpec.describe 'RawData API', type: :request do
  before(:each) do
    @auth_token = ApplicationController.generate_auth_token
  end

  it 'shows a raw_datum' do
    project = FactoryGirl.create(:project)
    raw_datum = FactoryGirl.create(:raw_datum, project: project)

    get api_v1_raw_datum_path(raw_datum, auth_token: @auth_token)

    expect(response).to be_success
    json = JSON.parse(response.body)
    expect(json).to eq(
      {
        'id' => raw_datum.id,
        'shape' => raw_datum.shape,
        'data' => Base64.encode64(Paperclip.io_adapters.for(raw_datum.data).read),
        'filename' => raw_datum.filename,
        'project_id' => raw_datum.project.id
      }
    )
  end

  it 'creates a raw_datum' do
    project = FactoryGirl.create(:project)
    raw_datum = FactoryGirl.build(:raw_datum, project: project)
    expect(RawDatum.count).to eq(0)

    post api_v1_raw_data_path(auth_token: @auth_token),
         params: {
           raw_datum: {
             'shape' => raw_datum.shape,
             'data' => fixture_file_upload("#{Rails.root}/spec/fixtures/text/valid2.md", 'text/plain'),
             'project_id' => raw_datum.project.id
           }
         }

    expect(response).to be_success
    json = JSON.parse(response.body)
    expect(RawDatum.count).to eq(1)
    raw_datum = RawDatum.first
    expect(json).to eq(
      {
        'id' => raw_datum.id,
        'shape' => raw_datum.shape,
        'data' => Base64.encode64(File.read("#{Rails.root}/spec/fixtures/text/valid2.md")),
        'filename' => raw_datum.filename,
        'project_id' => raw_datum.project.id
      }
    )
  end

  describe 'bulk creation' do
    it 'creates no raw_data for an empty list' do
      expect(RawDatum.count).to eq(0)

      post api_v1_raw_data_path(auth_token: @auth_token),
           params: {
             raw_data: []
           }

      expect(response).not_to be_success
    end

    it 'creates one raw_datum for a singleton' do
      project = FactoryGirl.create(:project)
      raw_datum = FactoryGirl.build(:raw_datum, project: project)
      expect(RawDatum.count).to eq(0)

      post api_v1_raw_data_path(auth_token: @auth_token),
           params: {
             raw_data: [
               {
                 'shape' => raw_datum.shape,
                 'data' => fixture_file_upload("#{Rails.root}/spec/fixtures/text/valid2.md", 'text/plain'),
                 'project_id' => raw_datum.project.id
               }
             ]
           }

      expect(response).to be_success
      json = JSON.parse(response.body)
      expect(RawDatum.count).to eq(1)
      raw_datum = RawDatum.first
      expect(json).to eq(
        {
          'id' => raw_datum.id,
          'shape' => raw_datum.shape,
          'data' => Base64.encode64(File.read("#{Rails.root}/spec/fixtures/text/valid2.md")),
          'filename' => raw_datum.filename,
          'project_id' => raw_datum.project.id
        }
      )
    end

    it 'creates multiple raw_data for a list of valid raw_data' do
      project = FactoryGirl.create(:project)
      raw_datum_1 = FactoryGirl.build(:raw_datum, project: project)
      raw_datum_2 = FactoryGirl.build(:raw_datum, project: project)
      expect(RawDatum.count).to eq(0)

      post api_v1_raw_data_path(auth_token: @auth_token),
           params: {
             raw_data: [
               {
                 'shape' => raw_datum_1.shape,
                 'data' => fixture_file_upload("#{Rails.root}/spec/fixtures/text/valid1.md", 'text/plain'),
                 'project_id' => raw_datum_1.project.id
               },
               {
                 'shape' => raw_datum_2.shape,
                 'data' => fixture_file_upload("#{Rails.root}/spec/fixtures/text/valid2.md", 'text/plain'),
                 'project_id' => raw_datum_2.project.id
               }
             ]
           }

      expect(response).to be_success
      json = JSON.parse(response.body)
      raw_datum_1 = RawDatum.first
      raw_datum_2 = RawDatum.second
      expect(json).to eq(
        [
          {
            'id' => raw_datum_1.id,
            'shape' => raw_datum_1.shape,
            'data' => Base64.encode64(File.read("#{Rails.root}/spec/fixtures/text/valid1.md")),
            'filename' => raw_datum_1.filename,
            'project_id' => raw_datum_1.project.id
          },
          {
            'id' => raw_datum_2.id,
            'shape' => raw_datum_2.shape,
            'data' => Base64.encode64(File.read("#{Rails.root}/spec/fixtures/text/valid2.md")),
            'filename' => raw_datum_2.filename,
            'project_id' => raw_datum_2.project.id
          },
        ]
      )
      expect(RawDatum.count).to eq(2)
    end

    it 'creates no raw_data for list of partly valid raw_data' do
      project = FactoryGirl.create(:project)
      raw_datum_1 = FactoryGirl.build(:raw_datum, project: project)
      raw_datum_2 = FactoryGirl.build(:raw_datum, project: project)
      expect(RawDatum.count).to eq(0)

      post api_v1_raw_data_path(auth_token: @auth_token),
           params: {
             raw_data: [
               {
                 'shape' => raw_datum_1.shape,
                 'data' => fixture_file_upload("#{Rails.root}/spec/fixtures/text/invalid.bin", 'application/octet-stream'),
                 'project_id' => raw_datum_1.project.id
               },
               {
                 'shape' => raw_datum_2.shape,
                 'data' => fixture_file_upload("#{Rails.root}/spec/fixtures/text/valid2.md", 'text/plain'),
                 'project_id' => raw_datum_2.project.id
               }
             ]
           }

      expect(response).not_to be_success
      expect(RawDatum.count).to eq(0)
    end
  end

  it 'patches a raw_datum' do
    project = FactoryGirl.create(:project)
    raw_datum = FactoryGirl.create(:raw_datum, project: project)
    raw_datum.data = File.new("#{Rails.root}/spec/fixtures/text/valid1.md")
    raw_datum.save!
    expect(RawDatum.count).to eq(1)

    patch api_v1_raw_datum_path(raw_datum, auth_token: @auth_token),
          params: {
            'data' => Base64.encode64(File.read("#{Rails.root}/spec/fixtures/text/valid2.md"))
          }

    expect(response).to be_success
    expect(RawDatum.count).to eq(1)
    updated_raw_datum = RawDatum.first
    json = JSON.parse(response.body)
    expect(json).to eq(
      {
        'id' => updated_raw_datum.id,
        'shape' => updated_raw_datum.shape,
        'data' => Base64.encode64(File.read("#{Rails.root}/spec/fixtures/text/valid2.md")),
        'filename' => updated_raw_datum.filename,
        'project_id' => updated_raw_datum.project.id
      }
    )
    expect(updated_raw_datum.id).to eq(raw_datum.id)
    expect(updated_raw_datum.shape).to eq(raw_datum.shape)
    expect(Paperclip.io_adapters.for(updated_raw_datum.data).read).to eq(File.read("#{Rails.root}/spec/fixtures/text/valid2.md"))
    expect(updated_raw_datum.filename).to eq(raw_datum.filename)
    expect(updated_raw_datum.project_id).to eq(raw_datum.project_id)
  end

  it 'destroys a raw_datum' do
    project = FactoryGirl.create(:project)
    raw_datum = FactoryGirl.create(:raw_datum, project: project)
    data = Base64.encode64(Paperclip.io_adapters.for(raw_datum.data).read)
    expect(RawDatum.count).to eq(1)

    delete api_v1_raw_datum_path(raw_datum, auth_token: @auth_token)

    expect(response).to be_success
    expect(RawDatum.count).to eq(0)
    json = JSON.parse(response.body)
    expect(json).to eq(
      {
        'id' => raw_datum.id,
        'shape' => raw_datum.shape,
        'data' => data,
        'filename' => raw_datum.filename,
        'project_id' => raw_datum.project.id
      }
    )
  end
end
