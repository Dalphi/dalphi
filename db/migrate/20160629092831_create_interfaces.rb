class CreateInterfaces < ActiveRecord::Migration[5.0]
  def change
    create_table :interfaces do |t|
      t.string :title
      t.integer :interface_type
      t.text :associated_problem_identifiers
      t.text :template
      t.text :stylesheet
      t.text :java_script

      t.timestamps
    end
  end
end
