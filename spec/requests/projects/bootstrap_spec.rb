require 'rails_helper'

RSpec.describe 'Project bootstrap', type: :request do
  before(:each) do
    stub_request(:get, 'http://example.com/bootstrap')
      .with(:headers => { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host' => 'example.com', 'User-Agent' => 'Ruby' })
      .to_return(status: 200, body: '', headers: {})

    @project = FactoryGirl.create :project,
                                  bootstrap_service: FactoryGirl.create(:bootstrap_service_request_test)
    sign_in(@project.user)
  end

  it "generates annotation documents by sending raw data to a bootstrap service" do
    raw_datum = FactoryGirl.create :raw_datum,
                                   data: File.new("#{Rails.root}/spec/fixtures/text/spiegel.txt"),
                                   project: @project
    annotation_document = FactoryGirl.build :annotation_document,
                                            project: @project,
                                            raw_datum: raw_datum,
                                            payload: {
                                              options: ['Enthält Personennamen', 'Enthält keine Personennamen'],
                                              content: File.new(raw_datum.data.path).read,
                                              paragraph_index: 0
                                            }

    stub_request(:post, 'http://example.com/bootstrap')
      .with(
        body: @project.bootstrap_data.to_json,
        headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type' => 'application/json', 'User-Agent' => 'Ruby' }
      )
      .to_return(
        status: 200,
        body: [annotation_document].to_json,
        headers: { 'Content-Type' => 'application/json' }
      )

    expect(AnnotationDocument.count).to eq(0)

    post project_bootstrap_path(@project)
    expect(response.header['Location'].gsub(/\?.*/, '')).to eq(project_annotation_documents_url(@project))

    expect(AnnotationDocument.count).to eq(1)

    generated_annotation_document = AnnotationDocument.first
    %w(interface_type raw_datum_id project_id payload rank skipped requested_at).each do |attribute|
      expect(generated_annotation_document.send(attribute)).to eq(annotation_document.send(attribute))
    end
  end
end
