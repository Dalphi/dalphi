class CreateJoinTableInterfaceProject < ActiveRecord::Migration[5.0]
  def change
    create_join_table :interfaces, :projects do |t|
      t.index [:interface_id, :project_id]
      t.index [:project_id, :interface_id]
    end
    add_foreign_key :interfaces_projects, :interfaces
    add_foreign_key :interfaces_projects, :projects
  end
end
