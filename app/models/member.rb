class Member < ApplicationRecord
    belongs_to :team
    has_many :retrospectives
    has_one :user

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

    def self.retro_readable_members(member_id,team_id)
        members = Member.joins(:user).where(team_id: team_id).where(users: {publish: [:teamonly,:everyone]}).select(:member_id)
        results =  members.collect{|r| r.member_id }
        results.push(member_id)
        return results.uniq
    end

    def self.retro_readable?(you, target_member_id)
        target = User.find_by(member_id: target_member_id)
        unless target
            return false
        end        
        #require 'byebug'; byebug
        if target.everyone?
            return true 
        elsif target.member_only? && target.member.team_id == you.member.team_id
            return true
        end
        return false
    end
    
end
