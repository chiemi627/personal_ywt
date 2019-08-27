class Retrospective < ApplicationRecord
    belongs_to :member

    def self.select_retro(team_id,date)
        if !team_id || (team_id=="all" && date=="all") then
            return Retrospective.all.order(:date, :member_id)       
        elsif team_id=="all" then
            return Retrospective.where(date: date).order(:date, :member_id)             
        elsif date=="all" then
            return Retrospective.joins(:member).where(members: {team_id: team_id}).order(:date, :member_id)        
        else
            return Retrospective.joins(:member).where(members: {team_id: team_id}, date: date).order(:date, :member_id)         
        end
    end

    def self.latest_day
        Retrospective.select(:date).order("date desc").limit(1)[0].date
    end

    def self.day_retro(day)
        Retrospective.where(date: day).joins(:member).order("members.team_id")
    end
end
