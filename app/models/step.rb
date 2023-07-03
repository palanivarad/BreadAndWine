class Step < ApplicationRecord
    belongs_to :recipe
    validates :direction, presence: true

    after_initialize :create_directions

    def create_directions
        @directions = Array.new
    end
end