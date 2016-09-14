FactoryGirl.define do
  factory :interface do
    title 'Fast NER Annotion'
    interface_type { FactoryGirl.create(:interface_type_ner_complete) }
    associated_problem_identifiers ['ner']

    factory :interface_2 do
      title 'another NER annotator'
    end

    factory :interface_text_nominal do
      interface_type { FactoryGirl.create(:interface_type_text_nominal) }
    end

    factory :interface_other do
      interface_type { FactoryGirl.create(:interface_type_other) }
    end
  end
end
