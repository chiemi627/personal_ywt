class Retrospective < ApplicationRecord
    belongs_to :member
    has_one :user, foreign_key: :member_id, primary_key: :member_id

    def self.select_retro(current_user,team_id,date)
        if !team_id || (team_id=="all" && date=="all") then
            return all_readable_retro(current_user)      
        elsif team_id=="all" then
            # return Retrospective.where(date: date).order(:date, :member_id)             
            return select_date_retro(current_user,date)
        elsif date=="all" then
            return select_team_retro(current_user,team_id)    
        else
            return select_team_date_retro(current_user,team_id,date)         
        end
    end

    def self.latest_day
        Retrospective.select(:date).order("date desc").limit(1)[0].date
    end

    def self.day_retro(user,day)
        if user.student?
            return Retrospective.joins(:user).where(date: day, users: {publish: :everyone}).includes([member: :team]).order("members.team_id")
        else
            Retrospective.where(date: day).joins(:member).includes([member: :team]).order("members.team_id")
        end
    end

    def self.all_readable_retro(user)
        if user.student?
            return Retrospective.joins(:user).where(users: {publish: :everyone}).order(:date, :member_id)
        else
            return Retrospective.all.includes([member: :team]).order(:date, :member_id)
        end
    end

    def self.select_date_retro(user,date)
        if user.student?
            return Retrospective.joins(:user).where(users: {publish: :everyone},date: date).order(:date, :member_id)
        else
            return Retrospective.where(date: date).includes([member: :team]).order(:date, :member_id)
        end
    end    

    def self.select_team_retro(user,team_id)
        if user.student?
            if user.member.team_id == team_id
                member_ids = Member.retro_readable_members(user.member_id,team_id)
                return Retrospective.where(member_id: member_ids).includes(:member).order(:date)
            else
                return Retrospective.joins([:member,:user]).where(users: {publish: :everyone}).where(members: {team_id: team_id}).includes(:member).order(:date, :member_id) 
            end
        else
            return Retrospective.joins(:member).where(members: {team_id: team_id}).order(:date, :member_id) 
        end
    end

    def self.select_team_date_retro(user,team_id,date)
        if user.student?
            if user.member.team_id == team_id
                member_ids = Member.retro_readable_members(user.member_id,team_id)
                return Retrospective.where(member_id: member_ids, date: date).includes(:member).order(:date)
            else
                return Retrospective.joins([:member,:user]).where(users: {publish: :everyone}, date: date).where(members: {team_id: team_id}).includes(:member).order(:date, :member_id) 
            end
        else
            return Retrospective.joins(:member).where(members: {team_id: team_id}, date: date).order(:date, :member_id) 
        end
    end

    def self.member_retro(user,member_id)
        if (user.student? && Member.retro_readable?(user,member_id)) || user.lecturer? || user.mentor?
            return Retrospective.where(member_id: member_id)
        end
    end

    def self.load_manaba_file(file)
        require 'csv'
        csv_data = CSV.read(file,'r:BOM|UTF-8', headers: false)
        csv_data.each do |row|
            if row[0] !~ /^#/ && row[14]
                stid = row[5]
                date = row[14].match(/^(\d{4}-\d{2}-\d{2}) \w*/)[1]                
                o = row[16]
                y = row[17]
                w = row[18]
                t = row[19]
                m = Member.find_by(account:stid)
                if m then
                    begin
                        Retrospective.create(member_id:m.id,date:date,objective:o,y:y,w:w,t:t)
                    rescue => exception
                        puts "#{stid}: the following error is found"
                        puts exception        
                    end
                else
                    puts "#{stid} can not be found."
                end    
          
            end
        end
    end

end

