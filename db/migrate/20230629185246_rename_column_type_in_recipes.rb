class RenameColumnTypeInRecipes < ActiveRecord::Migration[7.0]
  def change
    rename_column :recipes, :type, :kind
    remove_column :recipes, :posted_by
  end
end
