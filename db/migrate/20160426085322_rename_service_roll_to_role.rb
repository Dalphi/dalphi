class RenameServiceRollToRole < ActiveRecord::Migration[5.0]
  def change
    rename_column :services, :roll, :role
  end
end
