class RecipeIngredient < ApplicationRecord
    belongs_to :recipe
    belongs_to :ingredient
    validates :quantity, presence: true
    validates :ingredient_id, uniqueness: { scope: :recipe_id }
end