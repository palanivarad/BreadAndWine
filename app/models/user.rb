class User < ApplicationRecord
    before_save { self.email = email.downcase }
    validates :password, presence: true, length: { minimum: 6, maximum: 25 }
    validates :name, presence: true, length: { minimum: 5, maximum: 25 }
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, 
                uniqueness: { case_sensitive: false }, 
                format: { with: VALID_EMAIL_REGEX }
    has_secure_password
end