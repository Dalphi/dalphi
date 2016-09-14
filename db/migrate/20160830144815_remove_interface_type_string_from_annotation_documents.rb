class RemoveInterfaceTypeStringFromAnnotationDocuments < ActiveRecord::Migration[5.0]
  def change
    remove_column :annotation_documents, :interface_type
  end
end
