class AddRawDatumReferenceToAnnotationDocument < ActiveRecord::Migration[5.0]
  def change
    add_reference :annotation_documents, :raw_datum, index: true
  end
end
