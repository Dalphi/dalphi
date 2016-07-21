require 'rails_helper'

RSpec.describe 'Project merge', type: :request do
  before(:each) do
    stub_request(:get, 'http://example.com/merge')
      .with(:headers => { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host' => 'example.com', 'User-Agent' => 'Ruby' })
      .to_return(status: 200, body: '', headers: {})

    @project = FactoryGirl.create :project,
                                  merge_service: FactoryGirl.create(:merge_service_ci)
    sign_in(@project.user)
  end

  it "combines annotation documents into a raw datum by sending them to a merge service" do
    raw_datum = FactoryGirl.create :raw_datum,
                                   data: File.new("#{Rails.root}/spec/fixtures/text/unmerged.txt"),
                                   project: @project
    annotation_documents = [
      FactoryGirl.create(:annotation_document,
                       raw_datum: raw_datum,
                       rank: 1,
                       payload: {
                         options: ['Enthält Personennamen', 'Enthält keine Personennamen'],
                         label: "Enthält Personennamen",
                         content: "par1",
                         paragraph_index: 0
                       }),
      FactoryGirl.create(:annotation_document,
                       raw_datum: raw_datum,
                       rank: 2,
                       payload: {
                         options: ['Enthält Personennamen', 'Enthält keine Personennamen'],
                         label: "Enthält Personennamen",
                         content: "par2",
                         paragraph_index: 2
                       })
    ]

    stub_request(:post, 'http://example.com/merge')
      .with(
        body: @project.merge_data.to_json,
        headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type' => 'application/json', 'User-Agent' => 'Ruby' }
      )
      .to_return(
        status: 200,
        body: {
          content: Base64.encode64(File.new("#{Rails.root}/spec/fixtures/text/merged.txt").read),
          raw_datum_id: raw_datum.id
        }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )

    stub_request(:post, "http://example.com/merge").
             with(
                           :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'})
      .to_return(
        status: 200,
        body: {
          content: Base64.encode64(File.new("#{Rails.root}/spec/fixtures/text/merged.txt").read),
          raw_datum_id: raw_datum.id
        }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )

    expect(RawDatum.count).to eq(1)
    expect(AnnotationDocument.count).to eq(2)

    get project_merge_path(@project)
    expect(response.header['Location'].gsub(/\?.*/, '')).to eq(project_url(@project))

    expect(RawDatum.count).to eq(1)
    expect(AnnotationDocument.count).to eq(0)

    raw_datum.reload
    expect(File.new(raw_datum.data.path).read).to eq(
      File.new("#{Rails.root}/spec/fixtures/text/merged.txt").read
    )
  end
end
