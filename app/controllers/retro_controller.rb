class RetroController < ApplicationController

  def index
    if logged_in?
      if @current_user.student? 
        @retrospectives = Retrospective.where(member_id: @current_user.member_id)
        @dates = @retrospectives.collect{|r| r.date }.uniq.sort!{|a, b| b <=> a }   
      else
        redirect_to :retro_latest
      end
    end
  end

  def latest
    unless Retrospective.first
      @empty = true
      return
    end
    @day = Retrospective.latest_day    
    @parameters = {date: @day}
    if logged_in?
      @retrospectives = Retrospective.day_retro(@current_user,@day)
    end
    @team_items = Team.all.collect{|t| [t.name,t.id]}.unshift(["全てのチーム","all"])
    @date_items = Retrospective.select(:date).distinct.collect{|d| [d.date]}.unshift(["全ての日","all"])
    @dates = [@day]
  end

  def showall
    unless logged_in?
      flash[:danger]="ログインをしなければ振り返りを閲覧することはできません。"
      redirect_to :root
      return
    end
    @parameters = {team: selected_team(params[:team_id]), date: selected_date(params[:date])}
    @retrospectives = Retrospective.select_retro(@current_user,params[:team_id],params[:date])
    @team_items = Team.all.collect{|t| [t.name,t.id]}.unshift(["全てのチーム","all"])
    @date_items = Retrospective.select(:date).distinct.collect{|d| [d.date]}.sort!{|a, b| b <=> a }.unshift(["全ての日","all"])

    @dates = @retrospectives.collect{|r| r.date }.uniq.sort!{|a, b| b <=> a }

  end

  def day
    if params[:date]
      @day = params[:date]
    else
      @day = Retrospective.latest_day
    end
    @date_items = Retrospective.select(:date).distinct.collect{|d| [d.date]}.sort!{|a, b| b <=> a }.unshift(["全ての日","all"])
    if logged_in?
      @retrospectives = Retrospective.day_retro(@current_user,@day)
      if @retrospectives
        @teams = @retrospectives.collect{|r| r.member.team_id }.uniq
      end
    end
  end

  def member
    if params[:member_id] && Member.exists?(params[:member_id]) then
      @member = Member.find(params[:member_id])
    elsif !params[:member_id]
      @member = Member.first
    else
      flash[:danger] = "The member is not found."
      redirect_to :root
    end    
    if logged_in?
      @retrospectives = Retrospective.member_retro(@current_user,@member.id)
      if @retrospectives
        @dates = @retrospectives.collect{|r| r.date }.uniq.sort!{|a, b| b <=> a } 
      end
    end
  end

  def team
    if params[:team_id] && Team.exists?(params[:team_id]) then
      @team = Team.find(params[:team_id])
    elsif !params[:team_id]
      @team = Team.first
    else
      flash[:danger] = "The team is not found."
      redirect_to :root
    end
    @team_items = Team.all.collect{|t| [t.name,t.id]}
    if logged_in?      
      @retrospectives = Retrospective.select_team_retro(@current_user,@team.id)
      @dates = @retrospectives.collect{|r| r.date }.uniq.sort!{|a, b| b <=> a }
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
