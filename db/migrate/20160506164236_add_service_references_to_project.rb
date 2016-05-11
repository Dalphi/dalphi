class AddServiceReferencesToProject < ActiveRecord::Migration[5.0]
  def change
    add_reference :projects, :active_learning_service, references: :service, index: true
    add_reference :projects, :bootstrap_service, references: :service, index: true
    add_reference :projects, :machine_learning_service, references: :service, index: true
  end
end
