class AddAttachmentStylesheetToRawData < ActiveRecord::Migration
  def self.up
    remove_column :raw_data, :stylesheet
    change_table :raw_data do |t|
      t.attachment :stylesheet
    end
  end

  def self.down
    remove_attachment :raw_data, :stylesheet
    add_column :raw_data, :stylesheet, :text
  end
end
