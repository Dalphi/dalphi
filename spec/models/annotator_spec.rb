require 'rails_helper'

RSpec.describe Annotator, type: :model do
  before(:each) do
    @annotator = FactoryGirl.create(:annotator)
  end

  it 'should have a valid factory' do
    expect(@annotator).to be_valid
  end

  it { should validate_presence_of(:name) }

  it { should have_and_belong_to_many(:projects) }

  it { should have_many(:annotation_documents) }
end
