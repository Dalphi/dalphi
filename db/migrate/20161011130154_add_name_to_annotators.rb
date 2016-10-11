class AddNameToAnnotators < ActiveRecord::Migration[5.0]
  def change
    add_column :annotators, :name, :string
  end
end
