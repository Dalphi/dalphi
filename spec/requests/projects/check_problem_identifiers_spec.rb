require 'rails_helper'

RSpec.describe "Problem identifier check", type: :request do
  before(:each) do
    @project = FactoryGirl.create(:project)
    sign_in(@project.admin)
  end

  it 'shows an empty set of associated problem identifiers if no service is set' do
    @project.iterate_service = nil
    @project.machine_learning_service = nil
    @project.merge_service = nil
    @project.save!

    get check_problem_identifiers_path(@project), xhr: true
    expect(response).to be_success

    json = JSON.parse(response.body)
    expect(json).to eq(
      { 'associatedProblemIdentifiers' => [] }
    )
  end

  it 'shows a singleton if all associated services handle the same problem identifier' do
    @project.iterate_service = FactoryGirl.create(:iterate_service, problem_id: 'NER')
    @project.machine_learning_service = FactoryGirl.create(:machine_learning_service, problem_id: 'NER')
    @project.merge_service = FactoryGirl.create(:merge_service, problem_id: 'NER')
    @project.save!

    get check_problem_identifiers_path(@project), xhr: true
    expect(response).to be_success

    json = JSON.parse(response.body)
    expect(json).to eq(
      { 'associatedProblemIdentifiers' => ['NER'] }
    )
  end

  it 'should return a set of different problem identifiers if associated services handle them' do
    @project.iterate_service = FactoryGirl.create(:iterate_service, problem_id: 'HyperNER')
    @project.machine_learning_service = FactoryGirl.create(:machine_learning_service, problem_id: 'MegaNER')
    @project.merge_service = FactoryGirl.create(:merge_service, problem_id: 'NER')
    @project.save!

    get check_problem_identifiers_path(@project), xhr: true
    expect(response).to be_success

    json = JSON.parse(response.body)
    json['associatedProblemIdentifiers'].sort!
    expect(json).to eq(
      { 'associatedProblemIdentifiers' => ['HyperNER', 'MegaNER', 'NER'].sort }
    )
  end
end
