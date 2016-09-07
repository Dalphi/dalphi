require 'rails_helper'

RSpec.describe Statistic, type: :model do
  before(:each) do
    @statistic = FactoryGirl.create(:statistic)
    @statistic_precision = FactoryGirl.create(:statistic_precision)
    @statistic_recall = FactoryGirl.create(:statistic_recall)
    @statistic_f1_score = FactoryGirl.create(:statistic_f1_score)
    @statistic_num_annotations = FactoryGirl.create(:statistic_num_annotations)
  end

  it 'should have a valid factory' do
    expect(@statistic).to be_valid
    expect(@statistic_precision).to be_valid
    expect(@statistic_recall).to be_valid
    expect(@statistic_f1_score).to be_valid
    expect(@statistic_num_annotations).to be_valid
  end

  it { should validate_presence_of(:key) }

  it { should validate_uniqueness_of(:key).scoped_to(:iteration_index) }
end
