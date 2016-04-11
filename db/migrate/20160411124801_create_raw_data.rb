class CreateRawData < ActiveRecord::Migration[5.0]
  def change
    create_table :raw_data do |t|
      t.string :shape

      t.timestamps
    end
  end
end
