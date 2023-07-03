class ChangeFieldTypeForQuantity < ActiveRecord::Migration[7.0]
  def change
    change_column :recipe_ingredients, :quantity, :string
    rename_column :recipe_ingredients, :ingredient, :ingredient_id
    rename_column :recipe_ingredients, :recipe, :recipe_id

  end
end
