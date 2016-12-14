require 'rails_helper'

RSpec.describe 'Statistics API', type: :request do
  before(:each) do
    @auth_token = ApplicationController.generate_auth_token
  end

  it 'shows a statistic' do
    project = FactoryGirl.create(:project)
    statistic = FactoryGirl.create(:statistic, project: project)

    get api_v1_statistic_path(statistic, auth_token: @auth_token)

    expect(response).to be_success
    json = JSON.parse(response.body)
    expect(json).to eq(
      {
        'id' => statistic.id,
        'key' => statistic.key,
        'value' => statistic.value,
        'iteration_index' => statistic.iteration_index,
        'project_id' => statistic.project_id
      }
    )
  end

  it 'creates a statistic' do
    project = FactoryGirl.create(:project)
    statistic = FactoryGirl.build(:statistic, project: project)
    expect(Statistic.count).to eq(0)

    post api_v1_statistics_path(auth_token: @auth_token),
         params: {
           statistic: {
            'key' => statistic.key,
            'value' => statistic.value,
            'iteration_index' => statistic.iteration_index,
            'project_id' => statistic.project_id
           }
         }

    expect(response).to be_success
    json = JSON.parse(response.body)
    expect(Statistic.count).to eq(1)
    statistic = Statistic.first
    expect(json).to eq(
      {
        'id' => statistic.id,
        'key' => statistic.key,
        'value' => statistic.value,
        'iteration_index' => statistic.iteration_index,
        'project_id' => statistic.project_id
      }
    )
  end

  it 'creates a JSON stringify encoded statistic' do
    project = FactoryGirl.create(:project)
    statistic = FactoryGirl.build(:statistic, project: project)
    expect(Statistic.count).to eq(0)

    json_string = "{\"statistic\":{" \
                  "\"key\":\"#{statistic.key}\"," \
                  "\"value\":\"#{statistic.value}\"," \
                  "\"iteration_index\":#{statistic.iteration_index}," \
                  "\"project_id\":#{statistic.project_id}}" \
                  "}"

    post api_v1_statistics_path(auth_token: @auth_token),
         params: json_string,
         headers: {
           'CONTENT_TYPE' => 'application/json',
           'ACCEPT' => 'application/json'
         }

    expect(response).to be_success
    expect(Statistic.count).to eq(1)
    json = JSON.parse(response.body)
    statistic = Statistic.first
    expect(json).to eq(
      {
        'id' => statistic.id,
        'key' => statistic.key,
        'value' => statistic.value,
        'iteration_index' => statistic.iteration_index,
        'project_id' => statistic.project_id
      }
    )
  end

  it 'associates newly created statistic with the right project from raw_data ids' do
    raw_datum = FactoryGirl.create(:raw_datum)
    project = raw_datum.project
    statistic = FactoryGirl.build(:statistic, project: project)
    expect(Statistic.count).to eq(0)

    post api_v1_statistics_path(auth_token: @auth_token),
         params: {
           statistic: {
            'key' => statistic.key,
            'value' => statistic.value,
            'iteration_index' => statistic.iteration_index,
            'raw_data_ids' => [raw_datum.id]
           }
         }

    expect(response).to be_success
    expect(Statistic.count).to eq(1)
    json = JSON.parse(response.body)
    statistic = Statistic.first
    expect(json).to eq(
      {
        'id' => statistic.id,
        'key' => statistic.key,
        'value' => statistic.value,
        'iteration_index' => statistic.iteration_index,
        'project_id' => project.id
      }
    )
  end

  describe 'bulk creation' do
    it 'creates no statistics for an empty list' do
      expect(Statistic.count).to eq(0)

      post api_v1_statistics_path(auth_token: @auth_token),
           params: {
             statistics: []
           }

      expect(response).not_to be_success
    end

    it 'creates one statistic for a singleton' do
      project = FactoryGirl.create(:project)
      statistic = FactoryGirl.build(:statistic, project: project)
      expect(Statistic.count).to eq(0)

      post api_v1_statistics_path(auth_token: @auth_token),
           params: {
             statistics: [
               {
                 'key' => statistic.key,
                 'value' => statistic.value,
                 'iteration_index' => statistic.iteration_index,
                 'project_id' => statistic.project_id
               }
             ]
           }

      expect(response).to be_success
      json = JSON.parse(response.body)
      expect(Statistic.count).to eq(1)
      statistic = Statistic.first
      expect(json).to eq(
        [
          {
            'id' => statistic.id,
            'key' => statistic.key,
            'value' => statistic.value,
            'iteration_index' => statistic.iteration_index,
            'project_id' => statistic.project_id
          }
        ]
      )
    end

    it 'creates multiple statistics for a list of valid statistics' do
      project = FactoryGirl.create(:project)
      statistic_1 = FactoryGirl.build(:statistic, key: 'compliance', project: project)
      statistic_2 = FactoryGirl.build(:statistic, key: 'precision', project: project)
      expect(Statistic.count).to eq(0)

      post api_v1_statistics_path(auth_token: @auth_token),
           params: {
             statistics: [
               {
                 'key' => statistic_1.key,
                 'value' => statistic_1.value,
                 'iteration_index' => statistic_1.iteration_index,
                 'project_id' => statistic_1.project_id
               },
               {
                 'key' => statistic_2.key,
                 'value' => statistic_2.value,
                 'iteration_index' => statistic_2.iteration_index,
                 'project_id' => statistic_2.project_id
               }
             ]
           }

      expect(response).to be_success
      json = JSON.parse(response.body)
      statistic_1 = Statistic.first
      statistic_2 = Statistic.second
      expect(json).to eq(
        [
          {
            'id' => statistic_1.id,
            'key' => statistic_1.key,
            'value' => statistic_1.value,
            'iteration_index' => statistic_1.iteration_index,
            'project_id' => statistic_1.project_id
          },
          {
            'id' => statistic_2.id,
            'key' => statistic_2.key,
            'value' => statistic_2.value,
            'iteration_index' => statistic_2.iteration_index,
            'project_id' => statistic_2.project_id
          },
        ]
      )
      expect(Statistic.count).to eq(2)
    end

    it 'creates no statistics for list of partly valid statistics' do
      project = FactoryGirl.create(:project)
      statistic_1 = FactoryGirl.build(:statistic, key: 'compliance', project: project)
      statistic_2 = FactoryGirl.build(:statistic, key: 'precision', project: project)
      expect(Statistic.count).to eq(0)

      post api_v1_statistics_path(auth_token: @auth_token),
           params: {
             statistics: [
               {
                 'key' => statistic_1.key,
                 'value' => statistic_1.value,
                 'iteration_index' => statistic_1.iteration_index,
                 'project_id' => statistic_1.project_id
               },
               {
                 'value' => statistic_2.value,
                 'iteration_index' => statistic_2.iteration_index,
                 'project_id' => statistic_2.project_id
               }
             ]
           }

      expect(response).not_to be_success
      expect(Statistic.count).to eq(0)
    end

    it 'associates every statistic with the right project from raw_data ids' do
      raw_datum = FactoryGirl.create(:raw_datum)
      project = raw_datum.project
      statistic_1 = FactoryGirl.build(:statistic, key: 'compliance', project: project)
      statistic_2 = FactoryGirl.build(:statistic, key: 'precision', project: project)
      expect(Statistic.count).to eq(0)

      post api_v1_statistics_path(auth_token: @auth_token),
           params: {
             statistics: [
               {
                'key' => statistic_1.key,
                'value' => statistic_1.value,
                'iteration_index' => statistic_1.iteration_index,
                'raw_data_ids' => [raw_datum.id]
               },
               {
                'key' => statistic_2.key,
                'value' => statistic_2.value,
                'iteration_index' => statistic_2.iteration_index,
                'raw_data_ids' => [raw_datum.id]
               }
             ]
           }

      expect(response).to be_success
      expect(Statistic.count).to eq(2)
      json = JSON.parse(response.body)
      statistic_1 = Statistic.first
      statistic_2 = Statistic.second
      expect(json).to eq(
        [
          {
            'id' => statistic_1.id,
            'key' => statistic_1.key,
            'value' => statistic_1.value,
            'iteration_index' => statistic_1.iteration_index,
            'project_id' => project.id
          },
          {
            'id' => statistic_2.id,
            'key' => statistic_2.key,
            'value' => statistic_2.value,
            'iteration_index' => statistic_2.iteration_index,
            'project_id' => project.id
          },
        ]
      )
    end
  end

  it 'patches a statistic' do
    project = FactoryGirl.create(:project)
    statistic = FactoryGirl.create(:statistic, project: project)
    expect(Statistic.count).to eq(1)

    patch api_v1_statistic_path(statistic, auth_token: @auth_token),
          params: {
            statistic: {
              'key' => 'new_key',
              'value' => '0.987654321',
              'iteration_index' => 23
            }
          }

    expect(response).to be_success
    expect(Statistic.count).to eq(1)

    json = JSON.parse(response.body)
    expect(json).to eq(
      {
        'id' => statistic.id,
        'key' => 'new_key',
        'value' => '0.987654321',
        'iteration_index' => 23,
        'project_id' => statistic.project_id
      }
    )
    statistic.reload
    expect(statistic.key).to eq('new_key')
    expect(statistic.value).to eq('0.987654321')
    expect(statistic.iteration_index).to eq(23)
  end

  it 'patches a JSON stringify encoded statistic' do
    project = FactoryGirl.create(:project)
    statistic = FactoryGirl.create(:statistic, project: project)
    expect(Statistic.count).to eq(1)

    json_string = "{\"statistic\":" \
                  "{\"id\":#{statistic.id}," \
                  "\"key\":\"#{statistic.key}\"," \
                  "\"value\":\"#{statistic.value}\"," \
                  "\"iteration_index\":#{statistic.iteration_index}," \
                  "\"project_id\":#{statistic.project_id}}}"

    patch api_v1_statistic_path(statistic, auth_token: @auth_token),
          params: json_string,
          headers: {
            'CONTENT_TYPE' => 'application/json',
            'ACCEPT' => 'application/json'
          }

    expect(response).to be_success
    expect(Statistic.count).to eq(1)

    json = JSON.parse(response.body)
    statistic.reload
    expect(json).to eq(
      {
        'id' => statistic.id,
        'key' => statistic.key,
        'value' => statistic.value,
        'iteration_index' => statistic.iteration_index,
        'project_id' => statistic.project_id
      }
    )
  end

  it 'destroys a statistic' do
    project = FactoryGirl.create(:project)
    statistic = FactoryGirl.create(:statistic, project: project)
    expect(Statistic.count).to eq(1)

    delete api_v1_statistic_path(statistic, auth_token: @auth_token)

    expect(response).to be_success
    expect(Statistic.count).to eq(0)
    json = JSON.parse(response.body)
    expect(json).to eq(
      {
        'id' => statistic.id,
        'key' => statistic.key,
        'value' => statistic.value,
        'iteration_index' => statistic.iteration_index,
        'project_id' => statistic.project_id
      }
    )
  end
end
