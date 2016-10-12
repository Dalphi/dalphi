FactoryGirl.define do
  factory :annotation_document do
    raw_datum { FactoryGirl.create(:raw_datum) }
    interface_type { FactoryGirl.create(:interface_type) }
    payload '{"label":"testlabel","options":["option1","option2"],"content":"testcontent"}'
    requested_at nil

    factory :annotation_document_with_different_admin do
      raw_datum { FactoryGirl.create(:raw_datum_with_different_admin) }
    end

    factory :annotation_document_with_different_payload do
      payload '{"label":"super label","options":["wow","not so good"],"content":"awesome text"}'
    end
  end
end
