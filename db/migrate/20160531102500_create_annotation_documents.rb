class CreateAnnotationDocuments < ActiveRecord::Migration[5.0]
  def change
    create_table :annotation_documents do |t|
      t.integer :chunk_offset
      t.integer :type
      t.string :label
      t.text :options

      t.timestamps
    end
  end
end
