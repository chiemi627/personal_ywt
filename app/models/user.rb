class User < ApplicationRecord
    attr_accessor :remember_token, :activation_token
    before_validation :fill_registered_attributes
    before_save   :downcase_email
    before_create :create_activation_digest
    validates :name, presence: true, length: { maximum: 100 }
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, length: { maximum: 255 },
                      format: { with: VALID_EMAIL_REGEX },
                      uniqueness: { case_sensitive: false }
    validate :member_check
    has_secure_password    

    enum publish: [:everyone, :teamonly, :useronly]
    enum category: [:student, :lecturer, :mentor]

    has_many :retrospectives, foreign_key: :member_id, primary_key: :member_id
    belongs_to :member

    def authenticated?(attribute,token)
        digest = send("#{attribute}_digest")
        return false if digest.nil?
        BCrypt::Password.new(digest).is_password?(token)
    end

    def member
        unless self.member_id
            return 
        end
        if student?
            Member.find(member_id)
        else
            Mentor.find(member_id)
        end
    end

    def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end

    def authenticated?(attribute, token)
        digest = send("#{attribute}_digest")
        return false if digest.nil?
        BCrypt::Password.new(digest).is_password?(token)
    end

    private

    def member_check
        unless Mentor.where(email: email).exists? || Member.where(account: Member.tsukuba_student_id_from_email(email)).exists?
            errors.add(:email, "そのメールアドレスは受講生またはメンターとして登録されていません。")
        end
    end

    def fill_registered_attributes
        if mentor = Mentor.find_by(email: self.email)
            self.category = mentor.category
            self.member_id = mentor.id
        elsif member = Member.find_by(account: Member.tsukuba_student_id_from_email(self.email))
            self.category = "student"
            self.member_id = member.id            
        end
    end

    def User.new_token
        SecureRandom.urlsafe_base64
    end    

    def downcase_email
        self.email = email.downcase
    end

    def create_activation_digest
        self.activation_token  = User.new_token
        self.activation_digest = User.digest(activation_token)
    end

end
