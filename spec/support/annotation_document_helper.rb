module AnnotationDocumentHelper
  include ActiveJob::TestHelper

  def compare_annotation_document_with_json_response(model_instance, json_object)
    object_subset = json_object.except('requested_at')
                               .except('updated_at')

    expect(object_subset).to eq(
      {
        'id' => model_instance.id,
        'interface_type' => model_instance.interface_type.name,
        'meta' => model_instance.meta,
        'payload' => model_instance.payload,
        'rank' => model_instance.rank,
        'raw_datum_id' => model_instance.raw_datum.id,
        'skipped' => model_instance.skipped,
      }
    )
  end
end
