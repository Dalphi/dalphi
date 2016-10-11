require 'rails_helper'

RSpec.describe "AnnotationDocuments API", type: :request do
  it 'shows an annotation document' do
    annotation_document = FactoryGirl.create(:annotation_document)
    get "/api/v1/annotation_documents/#{annotation_document.id}"
    expect(response).to be_success
    json = JSON.parse(response.body)
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

  it 'creates an annotation document' do
    raw_datum = FactoryGirl.create(:raw_datum)
    expect(AnnotationDocument.all.count).to eq(0)

    post '/api/v1/annotation_documents',
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
    json = JSON.parse(response.body)
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
    expect(AnnotationDocument.all.count).to eq(1)
  end

  it 'patches an annotation document' do
    annotation_document = FactoryGirl.create(:annotation_document)
    expect(AnnotationDocument.all.count).to eq(1)

    patch "/api/v1/annotation_documents/#{annotation_document.id}",
          params: {
            annotation_document: {
              'interface_type' => 'type_name',
              'rank' => 123,
              'payload' => JSON.parse("{\"new\":\"payload\"}"),
              'skipped' => true
            }
          }

    expect(response).to be_success
    expect(AnnotationDocument.all.count).to eq(1)

    json = JSON.parse(response.body)
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
    expect(AnnotationDocument.all.count).to eq(1)

    file_path = Rails.root.join('spec/fixtures/text/annotation_documnent_payload_real_world.txt')
    annotation_document_definition = IO.read(file_path)

    patch "/api/v1/annotation_documents/#{annotation_document.id}",
          annotation_document_definition,
          {
            'CONTENT_TYPE' => 'application/json',
            'ACCEPT' => 'application/json'
          }

    expect(response).to be_success
    expect(AnnotationDocument.all.count).to eq(1)

    json = JSON.parse(response.body)
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
    expect(AnnotationDocument.all.count).to eq(1)

    delete "/api/v1/annotation_documents/#{annotation_document.id}"

    expect(response).to be_success
    expect(AnnotationDocument.all.count).to eq(0)

    json = JSON.parse(response.body)
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
