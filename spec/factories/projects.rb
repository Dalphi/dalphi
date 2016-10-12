FactoryGirl.define do
  factory :project do
    title 'Test project'
    description 'A test project for testing purposes only.'
    admin { FactoryGirl.create(:admin) }

    factory :project_with_different_admin do
      admin { FactoryGirl.create(:admin_2) }
    end

    factory :another_project do
      title 'Another test project'
      description 'A second test project for testing purposes only.'
      admin { FactoryGirl.create(:admin_3) }
    end
  end
end
