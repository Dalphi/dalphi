class AddAttachmentJavaScriptToRawData < ActiveRecord::Migration
  def self.up
    remove_column :raw_data, :java_script
    change_table :raw_data do |t|
      t.attachment :java_script
    end
  end

  def self.down
    remove_attachment :raw_data, :java_script
    add_column :raw_data, :java_script, :text
  end
end
