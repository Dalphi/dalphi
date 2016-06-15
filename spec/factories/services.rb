FactoryGirl.define do
  factory :active_learning_service, class: Service do
    role 0
    description 'Arnnes algorithm for optimal results'
    problem_id 'NER'
    url 'http://www.google.com'
    title 'Active Learning component'
    version 'v2.0.0-rc1'

    factory :bootstrap_service do
      role 1
      description 'Rorik algorithm for optimal results'
      url 'http://www.google.de'
      title 'NER Bootstrapper'
      version 'v1.0.0.beta3'
    end

    factory :machine_learning_service do
      role 2
      description 'Harbert algorithm for optimal results'
      url 'http://www.google.org'
      title 'NER algorithm'
      version '1.8.3'
    end

    factory :merge_service do
      role 3
      description 'Merge annotation documents and preprocessed raw_data'
      url 'http://www.google.us'
      title 'Merger'
      version '0.0.1'
    end
  end
end
