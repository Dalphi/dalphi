class ChangeInterfaceTypeOfInterfaces < ActiveRecord::Migration[5.0]
  def change
    change_column :interfaces, :interface_type, :string
  end
end
