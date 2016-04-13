require 'rails_helper'

RSpec.describe User, :type => :model do
  before(:each) do
    @user = FactoryGirl.create(:user)
  end

  it 'should have a valid factory' do
    expect(@user).to be_valid
  end

  it { should have_many(:projects) }
end
