FactoryGirl.define do
  factory :admin do
    email 'john.doe@example.com'
    password '12345678'

    factory :admin_2 do
      email 'john.appleseed@example.com'
    end

    factory :admin_3 do
      email 'andro.linuxoid@example.com'
    end
  end
end
