class AddAnnotableToAnnotationDocuments < ActiveRecord::Migration[5.0]
  def change
    add_reference :annotation_documents, :annotable, polymorphic: true, index: true
  end
end
