FactoryGirl.define do
  factory :annotation_document do
    raw_datum { FactoryGirl.create(:raw_datum) }
    interface_type 'text_nominal'
    payload '{"label":"testlabel","options":["option1","option2"],"content":"testcontent"}'
    requested_at nil

    factory :annotation_document_with_different_user do
      raw_datum { FactoryGirl.create(:raw_datum_with_different_user) }
    end

    factory :annotation_document_with_different_payload do
      payload '{"label":"super label","options":["wow","not so good"],"content":"awesome text"}'
    end
  end
end
