class AddAttachmentJavaScriptToInterfaces < ActiveRecord::Migration
  def self.up
    remove_column :interfaces, :java_script
    change_table :interfaces do |t|
      t.attachment :java_script
    end
  end

  def self.down
    remove_attachment :interfaces, :java_script
    add_column :interfaces, :java_script, :text
  end
end
