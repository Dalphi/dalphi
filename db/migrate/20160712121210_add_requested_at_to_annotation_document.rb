class AddRequestedAtToAnnotationDocument < ActiveRecord::Migration[5.0]
  def change
    add_column :annotation_documents, :requested_at, :datetime
  end
end
