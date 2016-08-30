FactoryGirl.define do
  factory :interface_type do
    name 'text_nominal'
    test_payload '{"options":["Enthält Personennamen","Enthält keine Personennamen"],"content":"Das ist Bundesinnenminister de Maizière.","paragraph_index":"60","label":"Enthält Personennamen"}'
  end
end
