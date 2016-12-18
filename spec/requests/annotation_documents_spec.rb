require 'rails_helper'

RSpec.configure do |c|
  c.include AnnotationDocumentHelper
end

RSpec.describe 'AnnotationDocuments internal API', type: :request do
  before(:each) do
    @annotation_document = FactoryGirl.create(:annotation_document)
    @project = @annotation_document.project
    sign_in(@project.admin)
  end

  it 'returns an annotation document if no count is specified' do
    expect(AnnotationDocument.all.count).to eq(1)
    patch "/projects/#{@project.id}/annotation_documents/next"

    expect(response).to be_success
    json = JSON.parse(response.body)['response']
    compare_annotation_document_with_json_response(@annotation_document, json.first)
  end

  it 'returns 2 annotation documents if a count of 2 is specified' do
    another_annotation_document = FactoryGirl.create(
                                    :annotation_document_with_different_payload,
                                    raw_datum: @annotation_document.raw_datum,
                                    interface_type: @annotation_document.interface_type
                                  )
    expect(AnnotationDocument.all.count).to eq(2)
    patch "/projects/#{@project.id}/annotation_documents/next",
          params: {
            count: 2
          }

    expect(response).to be_success
    json = JSON.parse(response.body)['response']
    expect(json.count).to eq(2)
    compare_annotation_document_with_json_response(@annotation_document, json.first)
    compare_annotation_document_with_json_response(another_annotation_document, json.last)
  end

  it 'returns 2 annotation documents, even if a count of 10 is specified but only 2 available' do
    another_annotation_document = FactoryGirl.create(
                                    :annotation_document_with_different_payload,
                                    raw_datum: @annotation_document.raw_datum,
                                    interface_type: @annotation_document.interface_type
                                  )
    expect(AnnotationDocument.all.count).to eq(2)
    patch "/projects/#{@project.id}/annotation_documents/next",
          params: {
            count: 10
          }

    expect(response).to be_success
    json = JSON.parse(response.body)['response']
    expect(json.count).to eq(2)
    compare_annotation_document_with_json_response(@annotation_document, json.first)
    compare_annotation_document_with_json_response(another_annotation_document, json.last)
  end

  it 'returns two different annotation documents sequentially' do
    another_annotation_document = FactoryGirl.create(
                                    :annotation_document_with_different_payload,
                                    raw_datum: @annotation_document.raw_datum,
                                    interface_type: @annotation_document.interface_type
                                  )
    expect(AnnotationDocument.all.count).to eq(2)
    patch "/projects/#{@project.id}/annotation_documents/next",
          params: {
            count: 1
          }

    expect(response).to be_success
    json = JSON.parse(response.body)['response']
    first_response_id = json.first['id']
    expect(first_response_id).to eq(@annotation_document.id)

    patch "/projects/#{@project.id}/annotation_documents/next",
          params: {
            count: 1
          }

    expect(response).to be_success
    json = JSON.parse(response.body)['response']
    second_response_id = json.first['id']
    expect(second_response_id).to eq(another_annotation_document.id)
    expect(first_response_id).not_to eq(second_response_id)
  end

  it 'sets the requested_at attribute of a served annotation document' do
    expect(AnnotationDocument.all.count).to eq(1)
    expect(AnnotationDocument.first.requested_at).to eq(nil)
    patch "/projects/#{@project.id}/annotation_documents/next"

    expect(response).to be_success
    expect(AnnotationDocument.first.requested_at).to be <= Time.zone.now
  end

  it 'returns an error (404) if no annotation document is available' do
    expect(AnnotationDocument.all.count).to eq(1)
    @annotation_document.destroy
    expect(AnnotationDocument.all.count).to eq(0)
    patch "/projects/#{@project.id}/annotation_documents/next"

    expect(response).to have_http_status(404)
  end

  it 'returns an error if an invalid project is specified' do
    expect(Project.all.count).to eq(1)
    undefined_project_id = -1
    expect(Project.find_by(id: undefined_project_id)).to eq(nil)

    patch "/projects/#{undefined_project_id}/annotation_documents/next"

    expect(response).to have_http_status(400)
  end
end
