class ChangeServiceProblemIdToString < ActiveRecord::Migration[5.0]
  def change
    change_column :services, :problem_id, :string
  end
end
