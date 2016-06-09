class ChangeAnnotationDocumentsTypeToInterfaceType < ActiveRecord::Migration[5.0]
  def change
    rename_column :annotation_documents, :type, :interface_type
  end
end
