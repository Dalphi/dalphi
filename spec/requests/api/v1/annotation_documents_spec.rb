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
        'payload' => "{\"label\":\"testlabel\",\"options\":[\"option1\",\"option2\"],\"content\":\"testcontent\"}",
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
         annotation_document:
           {
             'rank' => 0,
             'raw_datum_id' => raw_datum.id,
             'payload' => "{\"label\":\"testlabel\",\"options\":[\"option1\",\"option2\"],\"content\":\"testcontent\"}",
             'skipped' => false,
             'interface_type' => 'text_nominal'
           }

    expect(response).to be_success
    json = JSON.parse(response.body)
    expect(json).to eq(
      {
        'id' => 1,
        'interface_type' => 'text_nominal',
        'payload' => "{\"label\":\"testlabel\",\"options\":[\"option1\",\"option2\"],\"content\":\"testcontent\"}",
        'rank' => 0,
        'raw_datum_id' => raw_datum.id,
        'skipped' => false
      }
    )
    expect(AnnotationDocument.all.count).to eq(1)
  end

  it 'patches an annotation document' do
    annotation_document_1 = FactoryGirl.create(:annotation_document)

    annotation_document_2 = FactoryGirl.build(
                              :annotation_document,
                              raw_datum: annotation_document_1.raw_datum
                            )
    annotation_document_2.interface_type = 'text_nominal'
    annotation_document_2.payload = "{\"new\":\"payload\"}"
    annotation_document_2.rank = 123
    annotation_document_2.raw_datum_id = 456
    annotation_document_2.skipped = true

    patch "/api/v1/annotation_documents/#{annotation_document_1.id}",
          annotation_document: annotation_document_2.to_json

    expect(response).to be_success
    annotation_document_3 = AnnotationDocument.new(JSON.parse(response.body))
    annotation_document_1.reload

    expect(annotation_document_1).to eq(annotation_document_2)
    expect(annotation_document_2).to eq(annotation_document_3)
  end
end
