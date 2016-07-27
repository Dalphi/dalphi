require 'rails_helper'

RSpec.describe 'RawData update', type: :request do
  before(:each) do
    @project = FactoryGirl.create :project
    @raw_datum = FactoryGirl.create :raw_datum,
                                    data: File.new("#{Rails.root}/spec/fixtures/text/valid1.md"),
                                    filename: 'valid1.md',
                                    project: @project
    sign_in(@project.user)
  end

  it 'updates a raw datum' do
    expect(RawDatum.count).to eq(1)

    patch project_raw_datum_path(@project, @raw_datum),
          params: {
            raw_datum: {
              shape: 'text',
              data: fixture_file_upload("#{Rails.root}/spec/fixtures/text/valid2.md", 'text/plain')
            }
          }

    expect(response.header['Location'].gsub(/\?.*/, '')).to eq(project_raw_data_url(@project))
    expect(RawDatum.count).to eq(1)

    @raw_datum.reload
    expect(File.new(@raw_datum.data.path).read).to eq(File.new("#{Rails.root}/spec/fixtures/text/valid2.md").read)
    expect(@raw_datum.filename).to eq('valid2.md')
  end
end
