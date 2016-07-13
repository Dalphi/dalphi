class AddCompiledCodeToInterfaces < ActiveRecord::Migration[5.0]
  def change
    add_column :interfaces, :compiled_stylesheet, :text
    add_column :interfaces, :compiled_java_script, :text
  end
end
