class AddInterfaceTypeToInterface < ActiveRecord::Migration[5.0]
  def change
    add_reference :interfaces, :interface_type, index: true
  end
end
