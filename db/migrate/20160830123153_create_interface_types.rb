class CreateInterfaceTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :interface_types do |t|
      t.string :name
      t.text :test_payload

      t.timestamps
    end
  end
end
