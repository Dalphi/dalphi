class AddMetaToAnnotationDocuments < ActiveRecord::Migration[5.0]
  def change
    add_column :annotation_documents, :meta, :text
  end
end
