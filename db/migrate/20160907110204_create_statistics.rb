class CreateStatistics < ActiveRecord::Migration[5.0]
  def change
    create_table :statistics do |t|
      t.string :key
      t.string :value
      t.integer :iteration_index

      t.timestamps
    end
  end
end
