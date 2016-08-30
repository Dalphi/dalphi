class AddInterfaceTypesToAnnotationDocuments < ActiveRecord::Migration[5.0]
  def change
    add_reference :annotation_documents, :interface_type, index: true
  end
end
