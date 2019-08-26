class RetroController < ApplicationController

  def index
  end

  def showall
    @parameters = {team: selected_team(params[:team_id]), date: selected_date(params[:date])}
    @retrospectives = Retrospective.select_retro(params[:team_id],params[:date])
    @team_items = Team.all.collect{|t| [t.name,t.id]}.unshift(["全てのチーム","all"])
    @date_items = Retrospective.select(:date).distinct.collect{|d| [d.date]}.unshift(["全ての日","all"])

    @dates = @retrospectives.collect{|r| r.date }.uniq

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

  def member
    if params[:member_id] && Member.exists?(params[:member_id]) then
      @member = Member.find(params[:member_id])
      @retrospectives = Retrospective.where(member_id: @member)
      @dates = @retrospectives.collect{|r| r.date }.uniq
    else
      flash[:danger] = "The member is not found."
      redirect_to :root
    end    
  end

  def team
    if params[:team_id] && Team.exists?(params[:team_id]) then
      @team = Team.find(params[:team_id])
      @retrospectives =  Retrospective.joins(:member).where(members: {team_id: @team}).order(:date, :member_id)
      @dates = @retrospectives.collect{|r| r.date }.uniq    
    else
      flash[:danger] = "The team is not found."
      redirect_to :root
    end
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
