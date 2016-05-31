class AddMergeServiceReferenceToProject < ActiveRecord::Migration[5.0]
  def change
    add_reference :projects, :merge_service, references: :service, index: true
  end
end
