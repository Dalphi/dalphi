class ChangeInterfaceTypeInAnnotationDocument < ActiveRecord::Migration[5.0]
  def change
    change_column :annotation_documents, :interface_type, :string
  end
end
