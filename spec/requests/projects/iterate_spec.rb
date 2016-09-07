require 'rails_helper'

RSpec.describe 'Project iterate', type: :request do
  before(:each) do
    stub_request(:get, 'http://example.com/iterate')
      .with(:headers => { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Host' => 'example.com', 'User-Agent' => 'Ruby' })
      .to_return(status: 200, body: '', headers: {})

    @project = FactoryGirl.create :project,
                                  iterate_service: FactoryGirl.create(:iterate_service_request_test)
    @raw_datum = FactoryGirl.create :raw_datum,
                                    data: File.new("#{Rails.root}/spec/fixtures/text/spiegel.txt"),
                                    project: @project
    @annotation_document = FactoryGirl.build :annotation_document,
                                             project: @project,
                                             raw_datum: @raw_datum,
                                             payload: {
                                               options: ['Enthält Personennamen', 'Enthält keine Personennamen'],
                                               content: File.new(@raw_datum.data.path).read,
                                               paragraph_index: 0
                                             }
    sign_in(@project.user)
  end

  it 'generates annotation documents by sending raw data to an iterate service' do
    stub_request(:post, 'http://example.com/iterate')
      .with(
        body: @project.iterate_data.to_json,
        headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type' => 'application/json', 'User-Agent' => 'Ruby' }
      )
      .to_return(
        status: 200,
        body: {
                'annotation_documents' => [@annotation_document]
              }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )

    expect(AnnotationDocument.count).to eq(0)

    post project_iterate_path(@project)
    expect(response.header['Location'].gsub(/\?.*/, '')).to eq(project_annotation_documents_url(@project))

    expect(AnnotationDocument.count).to eq(1)

    generated_annotation_document = AnnotationDocument.first
    %w(interface_type raw_datum_id project_id payload rank skipped requested_at).each do |attribute|
      expect(generated_annotation_document.send(attribute)).to eq(@annotation_document.send(attribute))
    end
  end

  it 'generates statistics by sending raw data to an iterate service' do
    stub_request(:post, 'http://example.com/iterate')
      .with(
        body: @project.iterate_data.to_json,
        headers: { 'Accept' => '*/*', 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type' => 'application/json', 'User-Agent' => 'Ruby' }
      )
      .to_return(
        status: 200,
        body: {
                'statistics' => {
                  precision: 0.6284480772625486,
                  recall: 0.3800804335583704,
                  f1_score: 0.4736818346968625,
                  num_annotations: 4
                },
                'annotation_documents' => [@annotation_document]
              }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )

    expect(Statistic.count).to eq(0)

    post project_iterate_path(@project)
    expect(response.header['Location'].gsub(/\?.*/, '')).to eq(project_annotation_documents_url(@project))

    expect(Statistic.count).to eq(4)

    precision = Statistic.find(1)
    expect(precision.key).to eq('precision')
    expect(precision.value).to eq('0.6284480772625486')

    recall = Statistic.find(2)
    expect(recall.key).to eq('recall')
    expect(recall.value).to eq('0.3800804335583704')

    f1_score = Statistic.find(3)
    expect(f1_score.key).to eq('f1_score')
    expect(f1_score.value).to eq('0.4736818346968625')

    num_annotations = Statistic.find(4)
    expect(num_annotations.key).to eq('num_annotations')
    expect(num_annotations.value).to eq('4')

    expect(Statistic.all.map(&:iteration_index)).to eq([1, 1, 1, 1])
  end
end
