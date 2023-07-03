class Recipe < ApplicationRecord
    belongs_to :user
    has_many :recipe_ingredients, dependent: :delete_all
    has_many :steps, dependent: :delete_all
    has_many :ingredients, through: :recipe_ingredients
    has_many :favorites, dependent: :delete_all
    has_many :favorited_by, through: :favorites, source: :user
    has_one_attached :image
    validates :recipe_name, uniqueness: { scope: :user_id, message: "You already posted this recipe" }, presence: true
    validate :validate_image_file_type

    accepts_nested_attributes_for :recipe_ingredients, allow_destroy: true, reject_if: :all_blank 
    accepts_nested_attributes_for :steps, allow_destroy: true, reject_if: :all_blank 


    after_initialize :create_ingredient, :create_quantity

    def create_ingredient
        @ingredient = Array.new
    end
      
    def create_quantity
        @quantity = Array.new
    end

    def validate_image_file_type
        if image.attached? && !image.content_type.in?(%w(image/jpeg image/png image/gif))
          errors.add(:image, "must be a JPEG, PNG, or GIF image")
        end
    end

end