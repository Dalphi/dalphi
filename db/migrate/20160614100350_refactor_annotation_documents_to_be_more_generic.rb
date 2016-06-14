class RefactorAnnotationDocumentsToBeMoreGeneric < ActiveRecord::Migration[5.0]
  def change
    add_column :annotation_documents, :rank, :integer
    add_column :annotation_documents, :skipped, :boolean, default: false
    remove_column :annotation_documents, :chunk_offset
    remove_column :annotation_documents, :label
    remove_column :annotation_documents, :options
    rename_column :annotation_documents, :content, :payload
  end
end
