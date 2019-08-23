require 'csv'

class AdminController < ApplicationController
  before_action :admin_logged_in, only:[:load,:logout]

  def load
    if params[:retro_file] then
      load_retro_file(params[:retro_file])
      flash.now[:success] = "振り返りファイルを読み込みました。"
    end

    if params[:team_file] && params[:member_file] then
      load_team_and_member_file(params[:team_file],params[:member_file])
      flash.now[:success] = "チームリストとメンバーリストを読み込みました。"
    end

    if params[:mentor_file] then
      load_mentor_file(params[:mentor_file])
      flash.now[:success] = "メンターリストを読み込みました。"
    end
  end

  def login
  end

  def logged_in
    if params[:password]== ENV['PYWT_ADMIN_PASSWORD'] then
      session[:admin]="logged_in"
      redirect_to controller: 'admin', action: 'load'
    else
      flash.now[:danger] = "ログイン失敗"
      redirect_to :root
    end
  end

  def logout
    session.delete(:admin)
    flash.now[:success]="ログアウトしました"
    redirect_to :root
  end

  def admin_logged_in
    unless admin_logged_in? then
      redirect_to controller: 'admin', action: 'login'
    end
  end


  private 

  def admin_logged_in?
    flash.now[:danger]="ログインしてください"
    session[:admin]=="logged_in"
  end


  def load_team_and_member_file(team,member)
    teams = {}
    CSV.foreach(team.path, headers: false) do |row|
      teams[row[0]] = Team.create(name:row[1])
    end

    CSV.foreach(member.path,headers: false) do |row|
      if teams[row[2]] then
          Member.create(account:row[0],name:row[1],team_id:teams[row[2]].id)
      end
    end  
  end

  def load_mentor_file(mentor)
    CSV.foreach(mentor.path,headers: false) do |row|
      if row[0]!="" && row[1]!="" && row[2]!="" then
        Mentor.create(email:row[0],name:row[1],category:row[2])
      end
    end
  end
  
  def load_retro_file(file)
    CSV.foreach(file.path, headers: false) do |row|
      m = Member.find_by(account:row[0])
      if m then
          begin
              Retrospective.create(member_id:m.id,date:row[1],objective:row[2],y:row[3],w:row[4],t:row[5])        
          rescue => exception
              puts "#{row[0]}: the following error is found"
              puts exception        
          end
      else
          puts "#{row[0]} can not be found."
      end    
    end
  end
end
