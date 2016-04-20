require 'rails_helper'

RSpec.describe Service, type: :model do
  before(:each) do
    @al_service = FactoryGirl.build(:service_active_learning)
    @ml_service = FactoryGirl.build(:service_machine_learning)
    @bootstrap_service = FactoryGirl.build(:service_bootstrap)
  end

  it 'should have a valid factory' do
    expect(@al_service).to be_valid
    expect(@ml_service).to be_valid
    expect(@bootstrap_service).to be_valid
  end
end
