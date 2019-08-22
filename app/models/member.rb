class Member < ApplicationRecord
    belongs_to :team    
    has_many :retrospectives
end
