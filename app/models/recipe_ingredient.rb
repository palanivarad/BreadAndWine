class RecipeIngredient < ApplicationRecord
    belongs_to :recipe
    belongs_to :ingredient
    validates :quantity, presence: true
end