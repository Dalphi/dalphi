class AddProjectReferenceToAnnotationDocument < ActiveRecord::Migration[5.0]
  def change
    add_reference :annotation_documents, :project, index: true
    add_index :annotation_documents, [:project_id, :content_file_name], unique: true
  end
end
