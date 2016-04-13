FactoryGirl.define do
  factory :raw_datum do
    shape 'text'
    project { FactoryGirl.create(:project) }
  end
end
