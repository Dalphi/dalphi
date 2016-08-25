class DeleteActiveLearningServiceFromProjects < ActiveRecord::Migration[5.0]
  def change
    remove_reference :projects, :active_learning_service, index: true
  end
end
