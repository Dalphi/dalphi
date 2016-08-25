class RefactorBootstrapServiceToIterateService < ActiveRecord::Migration[5.0]
  def change
    rename_column :projects, :bootstrap_service_id, :iterate_service_id
    rename_index :projects, 'index_projects_on_bootstrap_service_id', 'index_projects_on_iterate_service_id'
  end
end
