class RemoveInterfaceTypeStringFromServices < ActiveRecord::Migration[5.0]
  def change
    remove_column :services, :interface_type
  end
end
