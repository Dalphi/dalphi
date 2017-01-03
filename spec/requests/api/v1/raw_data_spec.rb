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

  it 'creates a JSON stringify encoded raw_datum' do
    project = FactoryGirl.create(:project)
    raw_datum = FactoryGirl.build(:raw_datum, project: project)
    expect(RawDatum.count).to eq(0)

    json_string = "{\"raw_datum\":{" \
                  "\"shape\":\"#{raw_datum.shape}\"," \
                  "\"data\":\"#{fixture_file_upload("#{Rails.root}/spec/fixtures/text/valid2.md", 'text/plain')}\"" \
                  "\"project_id\".\"#{raw_datum.project.id}\"" \
                  "}}"

    post api_v1_raw_data_path(auth_token: @auth_token),
         params: json_string,
         headers: {
           'CONTENT_TYPE' => 'application/json',
           'ACCEPT' => 'application/json'
         }

    expect(response).to be_success
    expect(RawDatum.count).to eq(1)
    json = JSON.parse(response.body)
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

  # describe 'bulk creation' do
  #   it 'creates no raw_data for an empty list' do
  #     expect(RawDatum.count).to eq(0)

  #     post api_v1_raw_data_path(auth_token: @auth_token),
  #          params: {
  #            raw_data: []
  #          }

  #     expect(response).not_to be_success
  #   end

  #   it 'creates one raw_datum for a singleton' do
  #     project = FactoryGirl.create(:project)
  #     raw_datum = FactoryGirl.build(:raw_datum, project: project)
  #     expect(RawDatum.count).to eq(0)

  #     post api_v1_raw_data_path(auth_token: @auth_token),
  #          params: {
  #            raw_data: [
  #              {
  #                'key' => raw_datum.key,
  #                'value' => raw_datum.value,
  #                'iteration_index' => raw_datum.iteration_index,
  #                'project_id' => raw_datum.project_id
  #              }
  #            ]
  #          }

  #     expect(response).to be_success
  #     json = JSON.parse(response.body)
  #     expect(RawDatum.count).to eq(1)
  #     raw_datum = RawDatum.first
  #     expect(json).to eq(
  #       [
  #         {
  #           'id' => raw_datum.id,
  #           'key' => raw_datum.key,
  #           'value' => raw_datum.value,
  #           'iteration_index' => raw_datum.iteration_index,
  #           'project_id' => raw_datum.project_id
  #         }
  #       ]
  #     )
  #   end

  #   it 'creates multiple raw_data for a list of valid raw_data' do
  #     project = FactoryGirl.create(:project)
  #     raw_datum_1 = FactoryGirl.build(:raw_datum, key: 'compliance', project: project)
  #     raw_datum_2 = FactoryGirl.build(:raw_datum, key: 'precision', project: project)
  #     expect(RawDatum.count).to eq(0)

  #     post api_v1_raw_data_path(auth_token: @auth_token),
  #          params: {
  #            raw_data: [
  #              {
  #                'key' => raw_datum_1.key,
  #                'value' => raw_datum_1.value,
  #                'iteration_index' => raw_datum_1.iteration_index,
  #                'project_id' => raw_datum_1.project_id
  #              },
  #              {
  #                'key' => raw_datum_2.key,
  #                'value' => raw_datum_2.value,
  #                'iteration_index' => raw_datum_2.iteration_index,
  #                'project_id' => raw_datum_2.project_id
  #              }
  #            ]
  #          }

  #     expect(response).to be_success
  #     json = JSON.parse(response.body)
  #     raw_datum_1 = RawDatum.first
  #     raw_datum_2 = RawDatum.second
  #     expect(json).to eq(
  #       [
  #         {
  #           'id' => raw_datum_1.id,
  #           'key' => raw_datum_1.key,
  #           'value' => raw_datum_1.value,
  #           'iteration_index' => raw_datum_1.iteration_index,
  #           'project_id' => raw_datum_1.project_id
  #         },
  #         {
  #           'id' => raw_datum_2.id,
  #           'key' => raw_datum_2.key,
  #           'value' => raw_datum_2.value,
  #           'iteration_index' => raw_datum_2.iteration_index,
  #           'project_id' => raw_datum_2.project_id
  #         },
  #       ]
  #     )
  #     expect(RawDatum.count).to eq(2)
  #   end

  #   it 'creates no raw_data for list of partly valid raw_data' do
  #     project = FactoryGirl.create(:project)
  #     raw_datum_1 = FactoryGirl.build(:raw_datum, key: 'compliance', project: project)
  #     raw_datum_2 = FactoryGirl.build(:raw_datum, key: 'precision', project: project)
  #     expect(RawDatum.count).to eq(0)

  #     post api_v1_raw_data_path(auth_token: @auth_token),
  #          params: {
  #            raw_data: [
  #              {
  #                'key' => raw_datum_1.key,
  #                'value' => raw_datum_1.value,
  #                'iteration_index' => raw_datum_1.iteration_index,
  #                'project_id' => raw_datum_1.project_id
  #              },
  #              {
  #                'value' => raw_datum_2.value,
  #                'iteration_index' => raw_datum_2.iteration_index,
  #                'project_id' => raw_datum_2.project_id
  #              }
  #            ]
  #          }

  #     expect(response).not_to be_success
  #     expect(RawDatum.count).to eq(0)
  #   end

  #   it 'associates every raw_datum with the right project from raw_data ids' do
  #     raw_datum = FactoryGirl.create(:raw_datum)
  #     project = raw_datum.project
  #     raw_datum_1 = FactoryGirl.build(:raw_datum, key: 'compliance', project: project)
  #     raw_datum_2 = FactoryGirl.build(:raw_datum, key: 'precision', project: project)
  #     expect(RawDatum.count).to eq(0)

  #     post api_v1_raw_data_path(auth_token: @auth_token),
  #          params: {
  #            raw_data: [
  #              {
  #               'key' => raw_datum_1.key,
  #               'value' => raw_datum_1.value,
  #               'iteration_index' => raw_datum_1.iteration_index,
  #               'raw_data_ids' => [raw_datum.id]
  #              },
  #              {
  #               'key' => raw_datum_2.key,
  #               'value' => raw_datum_2.value,
  #               'iteration_index' => raw_datum_2.iteration_index,
  #               'raw_data_ids' => [raw_datum.id]
  #              }
  #            ]
  #          }

  #     expect(response).to be_success
  #     expect(RawDatum.count).to eq(2)
  #     json = JSON.parse(response.body)
  #     raw_datum_1 = RawDatum.first
  #     raw_datum_2 = RawDatum.second
  #     expect(json).to eq(
  #       [
  #         {
  #           'id' => raw_datum_1.id,
  #           'key' => raw_datum_1.key,
  #           'value' => raw_datum_1.value,
  #           'iteration_index' => raw_datum_1.iteration_index,
  #           'project_id' => project.id
  #         },
  #         {
  #           'id' => raw_datum_2.id,
  #           'key' => raw_datum_2.key,
  #           'value' => raw_datum_2.value,
  #           'iteration_index' => raw_datum_2.iteration_index,
  #           'project_id' => project.id
  #         },
  #       ]
  #     )
  #   end
  # end

  # it 'patches a raw_datum' do
  #   project = FactoryGirl.create(:project)
  #   raw_datum = FactoryGirl.create(:raw_datum, project: project)
  #   expect(RawDatum.count).to eq(1)

  #   patch api_v1_raw_datum_path(raw_datum, auth_token: @auth_token),
  #         params: {
  #           raw_datum: {
  #             'key' => 'new_key',
  #             'value' => '0.987654321',
  #             'iteration_index' => 23
  #           }
  #         }

  #   expect(response).to be_success
  #   expect(RawDatum.count).to eq(1)

  #   json = JSON.parse(response.body)
  #   expect(json).to eq(
  #     {
  #       'id' => raw_datum.id,
  #       'key' => 'new_key',
  #       'value' => '0.987654321',
  #       'iteration_index' => 23,
  #       'project_id' => raw_datum.project_id
  #     }
  #   )
  #   raw_datum.reload
  #   expect(raw_datum.key).to eq('new_key')
  #   expect(raw_datum.value).to eq('0.987654321')
  #   expect(raw_datum.iteration_index).to eq(23)
  # end

  # it 'patches a JSON stringify encoded raw_datum' do
  #   project = FactoryGirl.create(:project)
  #   raw_datum = FactoryGirl.create(:raw_datum, project: project)
  #   expect(RawDatum.count).to eq(1)

  #   json_string = "{\"raw_datum\":" \
  #                 "{\"id\":#{raw_datum.id}," \
  #                 "\"key\":\"#{raw_datum.key}\"," \
  #                 "\"value\":\"#{raw_datum.value}\"," \
  #                 "\"iteration_index\":#{raw_datum.iteration_index}," \
  #                 "\"project_id\":#{raw_datum.project_id}}}"

  #   patch api_v1_raw_datum_path(raw_datum, auth_token: @auth_token),
  #         params: json_string,
  #         headers: {
  #           'CONTENT_TYPE' => 'application/json',
  #           'ACCEPT' => 'application/json'
  #         }

  #   expect(response).to be_success
  #   expect(RawDatum.count).to eq(1)

  #   json = JSON.parse(response.body)
  #   raw_datum.reload
  #   expect(json).to eq(
  #     {
  #       'id' => raw_datum.id,
  #       'key' => raw_datum.key,
  #       'value' => raw_datum.value,
  #       'iteration_index' => raw_datum.iteration_index,
  #       'project_id' => raw_datum.project_id
  #     }
  #   )
  # end

  # it 'destroys a raw_datum' do
  #   project = FactoryGirl.create(:project)
  #   raw_datum = FactoryGirl.create(:raw_datum, project: project)
  #   expect(RawDatum.count).to eq(1)

  #   delete api_v1_raw_datum_path(raw_datum, auth_token: @auth_token)

  #   expect(response).to be_success
  #   expect(RawDatum.count).to eq(0)
  #   json = JSON.parse(response.body)
  #   expect(json).to eq(
  #     {
  #       'id' => raw_datum.id,
  #       'key' => raw_datum.key,
  #       'value' => raw_datum.value,
  #       'iteration_index' => raw_datum.iteration_index,
  #       'project_id' => raw_datum.project_id
  #     }
  #   )
  # end
end
