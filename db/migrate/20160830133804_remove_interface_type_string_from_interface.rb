class RemoveInterfaceTypeStringFromInterface < ActiveRecord::Migration[5.0]
  def change
    remove_column :interfaces, :interface_type
  end
end
