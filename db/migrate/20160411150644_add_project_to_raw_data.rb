class AddProjectToRawData < ActiveRecord::Migration[5.0]
  def change
    add_reference :raw_data, :project, index: true
  end
end
