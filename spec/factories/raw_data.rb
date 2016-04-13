FactoryGirl.define do
  factory :raw_datum do
    shape 'text'
    data File.new(Rails.root + 'spec/fixtures/text/lorem.txt')
    project { FactoryGirl.create(:project) }
  end
end
