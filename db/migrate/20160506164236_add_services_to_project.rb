class AddServicesToProject < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :active_learning_service, :integer
    add_column :projects, :bootstrap_service, :integer
    add_column :projects, :machine_learning_service, :integer
  end
end
