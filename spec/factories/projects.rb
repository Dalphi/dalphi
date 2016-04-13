FactoryGirl.define do
  factory :project do
    title 'Test project'
    description 'A test project for testing purposes only.'
    user { FactoryGirl.create(:user) }
  end
end
