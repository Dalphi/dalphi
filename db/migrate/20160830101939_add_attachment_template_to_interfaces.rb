class AddAttachmentTemplateToInterfaces < ActiveRecord::Migration[5.0]
  def self.up
    remove_column :interfaces, :template
    change_table :interfaces do |t|
      t.attachment :template
    end
  end

  def self.down
    remove_attachment :interfaces, :template
    add_column :interfaces, :template, :text
  end
end
