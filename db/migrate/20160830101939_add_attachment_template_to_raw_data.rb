class AddAttachmentTemplateToRawData < ActiveRecord::Migration
  def self.up
    remove_column :raw_data, :template
    change_table :raw_data do |t|
      t.attachment :template
    end
  end

  def self.down
    remove_attachment :raw_data, :template
    add_column :raw_data, :template, :text
  end
end
