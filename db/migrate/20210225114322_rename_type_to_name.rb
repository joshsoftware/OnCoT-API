class RenameTypeToName < ActiveRecord::Migration[5.2]
  def change
    rename_column :roles, :type, :name
  end
end

