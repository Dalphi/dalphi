FactoryGirl.define do
  factory :interface_type do
    name 'type_name'
    test_payload '{"options":["Enthält Personennamen","Enthält keine Personennamen"],"content":"Das ist Bundesinnenminister de Maizière.","paragraph_index":"60","label":"Enthält Personennamen"}'

    factory :interface_type_text_nominal do
      name 'text_nominal'
    end

    factory :interface_type_other do
      name 'other_interface_type'
    end
  end
end
