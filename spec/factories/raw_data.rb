FactoryGirl.define do
  factory :raw_datum do
    shape 'text'
    filename 'file.md'
    data File.new("#{Rails.root}/spec/fixtures/text/2000-06-08-com.handelsblatt.www.in9r34todujsm7zd5sk4ba0n.txt")
    project { FactoryGirl.create(:project) }

    factory :raw_datum_with_different_data do
      filename 'file2.md'
      data File.new("#{Rails.root}/spec/fixtures/text/ipsum.txt")
    end

    factory :raw_datum_with_different_admin do
      project { FactoryGirl.create(:project_with_different_admin) }
    end
  end
end
