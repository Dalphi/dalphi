class ChangeAnnotationDocumentIndex < ActiveRecord::Migration[5.0]
  def change
    remove_index :annotation_documents,
                 name: 'index_annotation_documents_on_project_id_and_content_file_name'
  end
end
