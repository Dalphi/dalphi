require 'rails_helper'

RSpec.describe "Problem identifier check", type: :request do
  before(:each) do
    @project = FactoryGirl.create(:project)
    sign_in(@project.user)
  end

  it 'shows an empty set of associated problem identifiers if no service is set' do
    @project.active_learning_service = nil
    @project.bootstrap_service = nil
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
    @project.active_learning_service = FactoryGirl.create(:active_learning_service, problem_id: 'NER')
    @project.bootstrap_service = FactoryGirl.create(:bootstrap_service, problem_id: 'NER')
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
    @project.active_learning_service = FactoryGirl.create(:active_learning_service, problem_id: 'UltraNER')
    @project.bootstrap_service = FactoryGirl.create(:bootstrap_service, problem_id: 'HyperNER')
    @project.machine_learning_service = FactoryGirl.create(:machine_learning_service, problem_id: 'MegaNER')
    @project.merge_service = FactoryGirl.create(:merge_service, problem_id: 'NER')
    @project.save!

    get check_problem_identifiers_path(@project), xhr: true
    expect(response).to be_success

    json = JSON.parse(response.body)
    json['associatedProblemIdentifiers'].sort!
    expect(json).to eq(
      { 'associatedProblemIdentifiers' => ['UltraNER', 'HyperNER', 'MegaNER', 'NER'].sort }
    )
  end
end
