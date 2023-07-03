class Ingredient < ApplicationRecord
    has_many :recipe_ingredients
    has_many :recipe, through: :recipe_ingredients
    validates :ingredient_name, presence: true
end