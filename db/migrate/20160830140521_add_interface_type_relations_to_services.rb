class AddInterfaceTypeRelationsToServices < ActiveRecord::Migration[5.0]
  def change
    create_join_table :interface_types, :services do |t|
      t.index [:interface_type_id, :service_id],
              name: 'index_iface_types_services_on_iface_type_id_and_service_id'
      t.index [:service_id, :interface_type_id],
              name: 'index_services_iface_types_on_iface_type_id_and_service_id'
    end

    add_foreign_key :interface_types_services, :interface_types
    add_foreign_key :interface_types_services, :services
  end
end
