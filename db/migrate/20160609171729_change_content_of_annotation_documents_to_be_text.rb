class ChangeContentOfAnnotationDocumentsToBeText < ActiveRecord::Migration[5.0]
  def change
    remove_attachment :annotation_documents, :content
    add_column :annotation_documents, :content, :text
  end
end
