class CreateRecipe < ActiveRecord::Migration[7.0]
  def change
    create_table :recipes do |t|
      t.string :recipe_name
      t.integer :posted_by
      t.string :cuisine
      t.string :type
      t.belongs_to :user, index: true, foreign_key: true
      t.timestamps
    end
  end
end
