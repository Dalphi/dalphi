FactoryGirl.define do
  factory :annotation_document do
    chunk_offset 0
    raw_datum { FactoryGirl.create(:raw_datum) }
    type 0
    options '["ok", "nö"]'
    content File.new(Rails.root + 'spec/fixtures/text/lorem_first_chunk.txt')
    label 'ok'
  end
end
