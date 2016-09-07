class AddProjectToStatistics < ActiveRecord::Migration[5.0]
  def change
    add_reference :statistics, :project, index: true, foreign_key: true
  end
end
