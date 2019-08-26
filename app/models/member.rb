class Member < ApplicationRecord
    belongs_to :team    
    has_many :retrospectives

    def tsukuba_email
        # 筑波大の学籍番号からemailアカウントを求める
        /(\w{2})(\w{7})/ =~ self.account
        "s#{$2}@s.tsukuba.ac.jp"
    end

end
