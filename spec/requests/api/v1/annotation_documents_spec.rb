require 'rails_helper'

RSpec.describe 'AnnotationDocuments API', type: :request do
  before(:each) do
    @auth_token = ApplicationController.generate_auth_token
  end

  it 'shows an annotation document' do
    annotation_document = FactoryGirl.create(:annotation_document)

    get api_v1_annotation_document_path(annotation_document, auth_token: @auth_token)

    expect(response).to be_success
    json = JSON.parse(response.body)['response']
    expect(json).to eq(
      {
        'id' => 1,
        'interface_type' => 'type_name',
        'payload' => {
          'label' => 'testlabel',
          'options' => [
            'option1',
            'option2'
          ],
          'content' => 'testcontent'
        },
        'rank' => nil,
        'raw_datum_id' => 1,
        'skipped' => nil
      }
    )
  end

  it 'creates an annotation document' do
    raw_datum = FactoryGirl.create(:raw_datum)
    expect(AnnotationDocument.count).to eq(0)

    post api_v1_annotation_documents_path(auth_token: @auth_token),
         params: {
           annotation_document: {
             'rank' => 0,
             'raw_datum_id' => raw_datum.id,
             'payload' => JSON.parse("{\"label\":\"testlabel\",\"options\":[\"option1\",\"option2\"],\"content\":\"testcontent\"}"),
             'skipped' => nil,
             'interface_type' => 'type_name'
           }
         }

    expect(response).to be_success
    json = JSON.parse(response.body)['response']
    expect(json).to eq(
      {
        'id' => 1,
        'interface_type' => 'type_name',
        'payload' => JSON.parse("{\"label\":\"testlabel\",\"options\":[\"option1\",\"option2\"],\"content\":\"testcontent\"}"),
        'rank' => 0,
        'raw_datum_id' => raw_datum.id,
        'skipped' => nil
      }
    )
    expect(AnnotationDocument.count).to eq(1)
  end

  describe 'bulk creation' do
    it 'creates no annotation documents for an empty list' do
      raw_datum = FactoryGirl.create(:raw_datum)
      expect(AnnotationDocument.count).to eq(0)

      post api_v1_annotation_documents_path(auth_token: @auth_token),
           params: {
             annotation_documents: []
           }

      expect(response).not_to be_success
    end

    it 'creates one annotation document for a singleton' do
      raw_datum = FactoryGirl.create(:raw_datum)
      expect(AnnotationDocument.count).to eq(0)

      post api_v1_annotation_documents_path(auth_token: @auth_token),
           params: {
             annotation_documents: [
               {
                 'rank' => 0,
                 'raw_datum_id' => raw_datum.id,
                 'payload' => JSON.parse("{\"label\":\"testlabel\",\"options\":[\"option1\",\"option2\"],\"content\":\"testcontent\"}"),
                 'skipped' => nil,
                 'interface_type' => 'type_name'
               }
             ]
           }

      expect(response).to be_success
      json = JSON.parse(response.body)['response']
      expect(json).to eq(
        {
          'id' => 1,
          'interface_type' => 'type_name',
          'payload' => JSON.parse("{\"label\":\"testlabel\",\"options\":[\"option1\",\"option2\"],\"content\":\"testcontent\"}"),
          'rank' => 0,
          'raw_datum_id' => raw_datum.id,
          'skipped' => nil
        }
      )
      expect(AnnotationDocument.count).to eq(1)
    end

    it 'creates multiple annotation documents for list of valid annotation documents' do
      raw_datum = FactoryGirl.create(:raw_datum)
      expect(AnnotationDocument.count).to eq(0)

      post api_v1_annotation_documents_path(auth_token: @auth_token),
           params: {
             annotation_documents: [
               {
                 'rank' => 0,
                 'raw_datum_id' => raw_datum.id,
                 'payload' => JSON.parse("{\"label\":\"testlabel\",\"options\":[\"option1\",\"option2\"],\"content\":\"testcontent\"}"),
                 'skipped' => nil,
                 'interface_type' => 'type_name'
               },
               {
                 'rank' => 1,
                 'raw_datum_id' => raw_datum.id,
                 'payload' => JSON.parse("{\"label\":\"anotherlabel\",\"options\":[\"option1\",\"option2\",\"option3\"],\"content\":\"othercontent\"}"),
                 'skipped' => nil,
                 'interface_type' => 'type_name'
               }
             ]
           }

      expect(response).to be_success
      json = JSON.parse(response.body)['response']
      expect(json).to eq(
        [
          {
            'id' => 1,
            'interface_type' => 'type_name',
            'payload' => JSON.parse("{\"label\":\"testlabel\",\"options\":[\"option1\",\"option2\"],\"content\":\"testcontent\"}"),
            'rank' => 0,
            'raw_datum_id' => raw_datum.id,
            'skipped' => nil
          },
          {
            'id' => 2,
            'interface_type' => 'type_name',
            'payload' => JSON.parse("{\"label\":\"anotherlabel\",\"options\":[\"option1\",\"option2\",\"option3\"],\"content\":\"othercontent\"}"),
            'rank' => 1,
            'raw_datum_id' => raw_datum.id,
            'skipped' => nil
          },
        ]
      )
      expect(AnnotationDocument.count).to eq(2)
    end

    it 'creates no annotation documents for list of partly valid annotation documents' do
      raw_datum = FactoryGirl.create(:raw_datum)
      expect(AnnotationDocument.count).to eq(0)

      post api_v1_annotation_documents_path(auth_token: @auth_token),
           params: {
             annotation_documents: [
               {
                 'rank' => 0,
                 'raw_datum_id' => raw_datum.id,
                 'payload' => nil,
                 'skipped' => nil,
                 'interface_type' => 'type_name'
               },
               {
                 'rank' => 1,
                 'raw_datum_id' => raw_datum.id,
                 'payload' => JSON.parse("{\"label\":\"anotherlabel\",\"options\":[\"option1\",\"option2\",\"option3\"],\"content\":\"othercontent\"}"),
                 'skipped' => nil,
                 'interface_type' => 'type_name'
               }
             ]
           }

      expect(response).not_to be_success
      expect(AnnotationDocument.count).to eq(0)
    end
  end

  it 'patches an annotation document' do
    annotation_document = FactoryGirl.create(:annotation_document)
    expect(AnnotationDocument.count).to eq(1)

    patch api_v1_annotation_document_path(annotation_document, auth_token: @auth_token),
          params: {
            annotation_document: {
              'interface_type' => 'type_name',
              'rank' => 123,
              'payload' => JSON.parse("{\"new\":\"payload\"}"),
              'skipped' => true
            }
          }

    expect(response).to be_success
    expect(AnnotationDocument.count).to eq(1)

    json = JSON.parse(response.body)['response']
    expect(json).to eq(
      'id' => 1,
      'interface_type' => 'type_name',
      'raw_datum_id' => 1,
      'payload' => JSON.parse("{\"new\":\"payload\"}"),
      'rank' => 123,
      'skipped' => true
    )

    annotation_document.reload
    expect(annotation_document.interface_type.name).to eq('type_name')
    expect(annotation_document.rank).to eq(123)
    expect(annotation_document.payload).to eq("{\"new\":\"payload\"}")
    expect(annotation_document.skipped).to eq(true)
  end

  it 'patches a JSON stringify encoded annotation document' do
    annotation_document = FactoryGirl.create(:annotation_document)
    expect(AnnotationDocument.count).to eq(1)

    file_path = Rails.root.join('spec/fixtures/text/annotation_documnent_payload_real_world.txt')
    annotation_document_definition = IO.read(file_path)

    patch api_v1_annotation_document_path(annotation_document, auth_token: @auth_token),
          params: annotation_document_definition,
          headers: {
            'CONTENT_TYPE' => 'application/json',
            'ACCEPT' => 'application/json'
          }

    expect(response).to be_success
    expect(AnnotationDocument.count).to eq(1)

    json = JSON.parse(response.body)['response']
    expect(json['interface_type']).to eq('ner_complete')
    expect(json['raw_datum_id']).to eq(1)
    expect(json['rank']).to eq(27)
    expect(json['skipped']).to eq(false)
    expect(json['payload']['content'][0][0][0]['term']).to eq('Anleihe')

    annotation_document.reload
    expect(annotation_document.interface_type.name).to eq('ner_complete')
    expect(annotation_document.raw_datum_id).to eq(1)
    expect(annotation_document.rank).to eq(27)
    expect(annotation_document.skipped).to eq(false)

    parsed_payload = annotation_document.relevant_attributes[:payload]
    expect(parsed_payload['content'][0][0][0]['term']).to eq('Anleihe')
  end

  it 'destroys an annotation document' do
    annotation_document = FactoryGirl.create(:annotation_document)
    expect(AnnotationDocument.count).to eq(1)

    delete api_v1_annotation_document_path(annotation_document, auth_token: @auth_token)

    expect(response).to be_success
    expect(AnnotationDocument.count).to eq(0)
    json = JSON.parse(response.body)['response']
    expect(json).to eq(
      {
        'id' => 1,
        'interface_type' => 'type_name',
        'payload' => JSON.parse("{\"label\":\"testlabel\",\"options\":[\"option1\",\"option2\"],\"content\":\"testcontent\"}"),
        'rank' => nil,
        'raw_datum_id' => 1,
        'skipped' => nil
      }
    )
  end
end
