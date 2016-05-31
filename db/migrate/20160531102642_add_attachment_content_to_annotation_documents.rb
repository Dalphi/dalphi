class AddAttachmentContentToAnnotationDocuments < ActiveRecord::Migration
  def self.up
    change_table :annotation_documents do |t|
      t.attachment :content
    end
  end

  def self.down
    remove_attachment :annotation_documents, :content
  end
end
