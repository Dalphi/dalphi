class CreateJoinTableAnnotatorProject < ActiveRecord::Migration[5.0]
  def change
    create_join_table :annotators, :projects do |t|
      t.index [:annotator_id, :project_id]
      t.index [:project_id, :annotator_id]
    end
    add_foreign_key :annotators_projects, :annotators
    add_foreign_key :annotators_projects, :projects
  end
end
