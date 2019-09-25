class Mentor < ApplicationRecord
    validates :email, presence: true, length: { maximum: 255 },
                      format: { with: VALID_EMAIL_REGEX },
                      uniqueness: { case_sensitive: false }    
    enum category: [:lecturer, :mentor]
end
