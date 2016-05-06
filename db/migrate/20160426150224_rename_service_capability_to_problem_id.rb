class RenameServiceCapabilityToProblemId < ActiveRecord::Migration[5.0]
  def change
    rename_column :services, :capability, :problem_id
  end
end
