class AddInterfaceTypesToServices < ActiveRecord::Migration[5.0]
  def change
    add_column :services, :interface_types, :text
  end
end
