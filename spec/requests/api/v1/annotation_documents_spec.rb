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
        'interface_type' => 'text_nominal',
        'payload' => Base64.encode64("{\"label\":\"testlabel\",\"options\":[\"option1\",\"option2\"],\"content\":\"testcontent\"}"),
        'rank' => nil,
        'raw_datum_id' => 1,
        'skipped' => false
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
             'payload' => Base64.encode64("{\"label\":\"testlabel\",\"options\":[\"option1\",\"option2\"],\"content\":\"testcontent\"}"),
             'skipped' => false,
             'interface_type' => 'text_nominal'
           }
         }

    expect(response).to be_success
    json = JSON.parse(response.body)
    expect(json).to eq(
      {
        'id' => 1,
        'interface_type' => 'text_nominal',
        'payload' => Base64.encode64("{\"label\":\"testlabel\",\"options\":[\"option1\",\"option2\"],\"content\":\"testcontent\"}"),
        'rank' => 0,
        'raw_datum_id' => raw_datum.id,
        'skipped' => false
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
              'interface_type' => 'text_nominal',
              'rank' => 123,
              'payload' => Base64.encode64("{\"new\":\"payload\"}"),
              'skipped' => true
            }
          }

    expect(response).to be_success
    expect(AnnotationDocument.all.count).to eq(1)

    json = JSON.parse(response.body)
    expect(json).to eq(
      'id' => 1,
      'interface_type' => 'text_nominal',
      'raw_datum_id' => 1,
      'payload' => Base64.encode64("{\"new\":\"payload\"}"),
      'rank' => 123,
      'skipped' => true
    )

    annotation_document.reload
    expect(annotation_document.interface_type).to eq('text_nominal')
    expect(annotation_document.rank).to eq(123)
    expect(annotation_document.payload).to eq("{\"new\":\"payload\"}")
    expect(annotation_document.skipped).to eq(true)
  end

  it 'destroys an annotation document' do
    annotation_document = FactoryGirl.create(:annotation_document)
    ap annotation_document
    expect(AnnotationDocument.all.count).to eq(1)

    delete "/api/v1/annotation_documents/#{annotation_document.id}"

    expect(response).to be_success
    expect(AnnotationDocument.all.count).to eq(0)

    json = JSON.parse(response.body)
    expect(json).to eq(
      {
        'id' => 1,
        'interface_type' => 'text_nominal',
        'payload' => Base64.encode64("{\"label\":\"testlabel\",\"options\":[\"option1\",\"option2\"],\"content\":\"testcontent\"}"),
        'rank' => nil,
        'raw_datum_id' => 1,
        'skipped' => false
      }
    )
  end
end
