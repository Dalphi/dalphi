require 'rails_helper'

RSpec.describe 'Annotation annotate', type: :request do
  before(:each) do
    @project = FactoryGirl.create :project
    sign_in(@project.admin)
  end

  it 'does not break for non-existing annotation documents' do
    get project_annotate_path(@project)

    expect(response.header['Location'].gsub(/\?.*/, '')).to eq(project_url(@project))
  end

  it 'renders a annotation document' do
    raw_datum = FactoryGirl.create :raw_datum,
                                   project: @project
    FactoryGirl.create :annotation_document,
                       raw_datum: raw_datum

    get project_annotate_path(@project)

    expect(response).to be_success
  end
end
