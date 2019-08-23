class RetroController < ApplicationController
  def showall
    @parameters = {team: selected_team(params[:team_id]), date: selected_date(params[:date])}
    @retrospectives = Retrospective.select_retro(params[:team_id],params[:date])
    @team_items = Team.all.collect{|t| [t.name,t.id]}.unshift(["全てのチーム","all"])
    @date_items = Retrospective.select(:date).distinct.collect{|d| [d.date]}.unshift(["全ての日","all"])

    @selected_dates = @retrospectives.collect{|r| r.date }.uniq

  end

  def day
    if params[:date]
      @day = params[:date]
    else
      @day = Retrospective.latest_day
    end
    @retrospectives = Retrospective.day_retro(@day)
    @teams = @retrospectives.collect{|r| r.member.team_id }.uniq
  end

  private

  def selected_team(id)
    if !id || id=="all" then
        return
    else
        return Team.find(id)          
    end
  end

  def selected_date(date)
    if !date || date=="all" then
      return 
    else
      return date
    end
  end

end
