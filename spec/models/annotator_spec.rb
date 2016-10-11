require 'rails_helper'

RSpec.describe Annotator, type: :model do
  before(:each) do
    @annotator = FactoryGirl.create(:annotator)
  end

  it 'should have a valid factory' do
    expect(@annotator).to be_valid
  end

  describe 'name' do
    it { should validate_presence_of(:name) }
  end

  describe 'projects' do
    it { should have_and_belong_to_many(:projects) }
  end
end
