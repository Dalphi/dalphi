payload_1 = {
  label: "testlabel",
  options: [
    "option1",
    "option2"
  ],
  content: "testcontent"
}

payload_2 = {
  label: "super label",
  options: [
    "wow",
    "not so good"
  ],
  content: "awesome text"
}

FactoryGirl.define do
  factory :annotation_document do
    raw_datum { FactoryGirl.create(:raw_datum) }
    interface_type { FactoryGirl.create(:interface_type) }
    payload payload_1
    requested_at nil

    factory :annotation_document_with_different_admin do
      raw_datum { FactoryGirl.create(:raw_datum_with_different_admin) }
    end

    factory :annotation_document_with_different_payload do
      payload payload_2
    end
  end
end
