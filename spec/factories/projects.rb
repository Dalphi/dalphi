FactoryGirl.define do
  factory :project do
    title 'Test project'
    description 'A test project for testing purposes only.'
    user { FactoryGirl.create(:user) }

    factory :another_project do
      title 'Another test project'
      description 'A second test project for testing purposes only.'
    end
  end
end
