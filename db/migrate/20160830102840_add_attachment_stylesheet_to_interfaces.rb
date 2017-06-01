class AddAttachmentStylesheetToInterfaces < ActiveRecord::Migration[5.0]
  def self.up
    remove_column :interfaces, :stylesheet
    change_table :interfaces do |t|
      t.attachment :stylesheet
    end
  end

  def self.down
    remove_attachment :interfaces, :stylesheet
    add_column :interfaces, :stylesheet, :text
  end
end
