FactoryGirl.define do
  factory :annotation_document do
    chunk_offset 0
    raw_datum { FactoryGirl.create(:raw_datum) }
    interface_type 0
    options ['ok', 'nö']
    content File.new(Rails.root + 'spec/fixtures/text/lorem_first_chunk.txt')
    label ''

    factory :annotation_ducument_with_different_user do
      raw_datum { FactoryGirl.create(:raw_datum_with_different_user) }
    end
  end
end
