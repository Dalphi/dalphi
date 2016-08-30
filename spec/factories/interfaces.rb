FactoryGirl.define do
  factory :interface do
    title 'Fast NER Annotion'
    interface_type 'text_nominal'
    associated_problem_identifiers ['ner']
    #java_script File.new("#{Rails.root}/spec/fixtures/interfaces/text_nominal.js")
    #stylesheet File.new("#{Rails.root}/spec/fixtures/interfaces/text_nominal.css")
    #template File.new("#{Rails.root}/spec/fixtures/interfaces/text_nominal.html")

    factory :interface_2 do
      title 'another NER annotator'
    end
  end
end
