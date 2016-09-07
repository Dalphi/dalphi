FactoryGirl.define do
  factory :interface do
    title 'Fast NER Annotion'
    interface_type 'text_nominal'
    associated_problem_identifiers ['ner']

    factory :interface_2 do
      title 'another NER annotator'
    end
  end
end
