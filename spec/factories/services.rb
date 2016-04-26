FactoryGirl.define do
  factory :service_active_learning, class: Service do
    role 0
    description 'Harbert algorithm for optimal results'
    problem_id 0
    url 'http://localhost:3000'
    title 'Active Learning component'
    version 'v2.0.0-rc1'

    factory :service_bootstrap do
      role 1
      description 'Rorik algorithm for optimal results'
      url 'http://localhost:3000'
      title 'NER Bootstrapper'
      version 'v1.0.0.beta3'
    end

    factory :service_machine_learning do
      role 2
      description 'Arnnes algorithm for optimal results'
      url 'http://localhost:3000'
      title 'NER algorithm'
      version '1.8.3'
    end
  end
end
