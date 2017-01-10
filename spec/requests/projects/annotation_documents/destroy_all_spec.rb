require 'rails_helper'

RSpec.describe 'AnnotationDocument destroy all', type: :request do
  before(:each) do
    @project = FactoryGirl.create :project
    @raw_datum = FactoryGirl.create :raw_datum,
                                    project: @project
    @annotation_document_1 = FactoryGirl.create :annotation_document,
                                                raw_datum: @raw_datum
    @annotation_document_2 = FactoryGirl.create :annotation_document_with_different_payload,
                                                interface_type: @annotation_document_1.interface_type,
                                                raw_datum: @raw_datum
    sign_in(@project.admin)
  end

  it 'destroys all annotation documents from a project' do
    expect(AnnotationDocument.count).to eq(2)

    delete project_annotation_documents_path(@project),
           params: {
             project: {
               id: @project.id
             }
           }

    expect(response.header['Location'].gsub(/\?.*/, '')).to eq(project_annotation_documents_url(@project))
    expect(AnnotationDocument.count).to eq(0)
  end
end
