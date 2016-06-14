FactoryGirl.define do
  factory :user do
    email 'john.doe@example.com'
    password '12345678'

    factory :user_2 do
      email 'john.appleseed@example.com'
    end

    factory :user_3 do
      email 'andro.linuxoid@example.com'
    end
  end
end
