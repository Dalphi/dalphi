module AnnotationDocumentHelper
  include ActiveJob::TestHelper

  def type_is_valid(model_instance, type_identifier, target_enum)
    model_instance.type = type_identifier
    expect(model_instance).to be_valid
  end
end
