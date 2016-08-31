require 'rails_helper'

RSpec.describe 'RawData create', type: :request do
  before(:each) do
    @project = FactoryGirl.create :project
    sign_in(@project.user)
  end

  it 'create a raw datum' do
    expect(RawDatum.count).to eq(0)

    post project_raw_data_path(@project),
         params: {
           raw_datum: {
             shape: 'text',
             data: [fixture_file_upload("#{Rails.root}/spec/fixtures/zip/subdirectory2.zip", 'application/zip')]
           }
         }

    expect(response.header['Location'].gsub(/\?.*/, '')).to eq(project_raw_data_url(@project))
    expect(RawDatum.count).to eq(2)
  end
end
