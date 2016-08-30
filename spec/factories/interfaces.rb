FactoryGirl.define do
  factory :interface do
    title 'Fast NER Annotion'
    interface_type { FactoryGirl.create(:interface_type) }
    associated_problem_identifiers ['ner']
    template '<p class="question">Please anwer the question: {{question}}</p>'
    stylesheet 'p { color: #000000 }'
    java_script ''

    factory :interface_2 do
      title 'another NER annotator'
      template '<p class="question">Think about this: {{that}}</p>'
    end
  end
end
