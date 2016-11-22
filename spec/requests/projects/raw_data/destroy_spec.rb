require 'rails_helper'

RSpec.describe 'RawDatum destroy', type: :request do
  before(:each) do
    @project = FactoryGirl.create :project
    @raw_datum = FactoryGirl.create :raw_datum,
                                    project: @project
    sign_in(@project.admin)
  end

  it 'destroys a raw_datum' do
    expect(RawDatum.count).to eq(1)

    delete project_raw_datum_path(@project, @raw_datum),
           params: {
             project: {
               id: @raw_datum.id
             }
           }

    expect(response.header['Location'].gsub(/\?.*/, '')).to eq(project_raw_data_url(@project))
    expect(RawDatum.count).to eq(0)
  end
end
