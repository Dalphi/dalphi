FactoryGirl.define do
  factory :raw_datum do
    shape 'text'
    filename 'file.md'
    data File.new("#{Rails.root}/spec/fixtures/text/lorem.txt")
    project { FactoryGirl.create(:project) }

    factory :raw_datum_with_different_data do
      filename 'file2.md'
      data File.new("#{Rails.root}/spec/fixtures/text/ipsum.txt")
    end

    factory :raw_datum_with_different_user do
      project { FactoryGirl.create(:project_with_different_user) }
    end
  end
end
