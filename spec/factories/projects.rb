FactoryGirl.define do
  factory :project do
    title 'Test project'
    description 'A test project for testing purposes only.'
    user { FactoryGirl.create(:user) }

    factory :project_with_different_user do
      user { FactoryGirl.create(:user_2) }
    end

    factory :another_project do
      title 'Another test project'
      description 'A second test project for testing purposes only.'
      user { FactoryGirl.create(:user_3) }
    end
  end
end
