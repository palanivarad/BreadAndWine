class User < ApplicationRecord

    before_create :confirmation_token
    
    has_many :recipes
    has_many :favorites, dependent: :delete_all
    has_many :favorite_recipes, through: :favorites, source: :recipe
    before_save { self.email = email.downcase }
    validates :password, presence: true, length: { minimum: 6, maximum: 25 }
    validates :name, presence: true, length: { minimum: 5, maximum: 25 }
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, 
                uniqueness: { case_sensitive: false }, 
                format: { with: VALID_EMAIL_REGEX }
    has_secure_password

    def email_activate
        self.email_confirmed = true
        self.confirm_token = nil
        save!(:validate => false)
    end

    def generate_password_token!
        self.reset_password_token = generate_token
        self.reset_password_sent_at = Time.now.utc
        save!(:validate => false)
    end
       
    def password_token_valid?
        (self.reset_password_sent_at + 4.hours) > Time.now.utc
    end
    
    def reset_password!(password)
        self.reset_password_token = nil
        self.password = password
        save!(:validate => false)
    end       
       

    private

    def confirmation_token
        if self.confirm_token.blank?
            self.confirm_token = SecureRandom.urlsafe_base64.to_s
        end
    end

    def generate_token
        SecureRandom.hex(10)
    end

    
end