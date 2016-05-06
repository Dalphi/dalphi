class CreateServices < ActiveRecord::Migration[5.0]
  def change
    create_table :services do |t|
      t.integer :roll
      t.string :description
      t.integer :capability
      t.string :url
      t.string :title
      t.string :version

      t.timestamps
    end
  end
end
