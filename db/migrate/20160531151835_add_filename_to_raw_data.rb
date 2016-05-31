class AddFilenameToRawData < ActiveRecord::Migration[5.0]
  def change
    add_column :raw_data, :filename, :string
  end
end
