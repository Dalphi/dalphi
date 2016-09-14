FactoryGirl.define do
  # interface_type_instance = FactoryGirl.create(:interface_type)
  factory :service, class: Service do
    role 0
    description 'Arnnes algorithm for optimal results'
    problem_id 'NER'
    url 'http://www.google.com'
    title 'Dummy service component'
    version 'v2.0.0-rc1'
    interface_types { [FactoryGirl.create(:interface_type)] }

    factory :iterate_service do
      role 0
      description 'Rorik algorithm for optimal results'
      url 'http://www.google.de'
      title 'NER Iterator'
      version 'v1.0.0.beta3'
      interface_types { [FactoryGirl.create(:interface_type_text_nominal)] }
    end

    factory :iterate_service_request_test do
      role 0
      description 'Iterate Service for request tests'
      url 'http://example.com/iterate'
      title 'Request Test Iterate Service'
      version 'v0.1'
      interface_types { [FactoryGirl.create(:interface_type_other)] }
    end

    factory :machine_learning_service do
      role 2
      description 'Harbert algorithm for optimal results'
      url 'http://www.google.org'
      title 'NER algorithm'
      version '1.8.3'
      interface_types []
    end

    factory :merge_service do
      role 1
      description 'Merge annotation documents and preprocessed raw_data'
      url 'http://www.google.us'
      title 'Merger'
      version '0.0.1'
      interface_types []
    end

    factory :merge_service_request_test do
      role 1
      description 'Merge Service for request tests'
      url 'http://example.com/merge'
      title 'Request Test Merge Service'
      version '0.1'
      interface_types []
    end
  end
end
