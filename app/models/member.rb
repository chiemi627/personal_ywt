class Member < ApplicationRecord
    belongs_to :team    
    has_many :retrospectives

    def tsukuba_email
        Member.tsukuba_email(account)
    end

    def tsukuba_student_id
        Member.tsukuba_student_id_from_email(email)
    end


    def self.tsukuba_email(account)
        # 筑波大の学籍番号からemailアドレスを求める
        /(\w{2})(\w{7})/ =~ account
        "s#{$2}@s.tsukuba.ac.jp"
    end

    def self.tsukuba_student_id_from_email(email)
        # 筑波大のemailアドレスから学籍番号を求める
        /s(\w+)@s.tsukuba.ac.jp/ =~ email
        "20#{$1}"
    end

end
