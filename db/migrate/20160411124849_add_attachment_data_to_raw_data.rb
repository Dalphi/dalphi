class AddAttachmentDataToRawData < ActiveRecord::Migration[5.0]
  def self.up
    change_table :raw_data do |t|
      t.attachment :data
    end
  end

  def self.down
    remove_attachment :raw_data, :data
  end
end
