require 'rails_helper'

RSpec.describe Admin, :type => :model do
  before(:each) do
    @admin = FactoryGirl.create(:admin)
  end

  it 'should have a valid factory' do
    expect(@admin).to be_valid
  end

  it { should have_many(:projects).dependent(:destroy) }
end
