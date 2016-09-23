class RenameUserToAdmin < ActiveRecord::Migration[5.0]
  def change
    rename_table :users, :admins
    rename_index :admins, 'index_users_on_email', 'index_admins_on_email'

    rename_column :projects, :user_id, :admin_id
    rename_index :projects, 'index_projects_on_user_id', 'index_projects_on_admin_id'
  end
end
