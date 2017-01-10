require 'rails_helper'

RSpec.describe 'RawDatum destroy all', type: :request do
  before(:each) do
    @project = FactoryGirl.create :project
    @raw_datum = FactoryGirl.create :raw_datum,
                                    project: @project
    @raw_datum = FactoryGirl.create :raw_datum_with_different_data,
                                    project: @project
    sign_in(@project.admin)
  end

  it 'destroys all raw data association from a project' do
    expect(RawDatum.count).to eq(2)

    delete project_raw_data_path(@project),
           params: {
             project: {
               id: @raw_datum.id
             }
           }

    expect(response.header['Location'].gsub(/\?.*/, '')).to eq(project_raw_data_url(@project))
    expect(RawDatum.count).to eq(0)
  end
end
