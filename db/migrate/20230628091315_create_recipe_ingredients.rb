class CreateRecipeIngredients < ActiveRecord::Migration[7.0]
  def change
    create_table :recipe_ingredients do |t|
      t.integer :recipe
      t.integer :ingredient
      t.float :quantity      
      t.timestamps
    end
  end
end
