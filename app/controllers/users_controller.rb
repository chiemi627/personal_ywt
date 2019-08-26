class UsersController < ApplicationController
  before_action :logged_in, only:[:index]

  def new
    @user = User.new
  end

  def index
    @user = @current_user
  end

  def create
    # メールアドレスをチェックする：一致したらスタッフ登録
    if params[:user][:email] && Mentor.where(email: params[:user][:email]).exists?
      mentor = Mentor.find_by(email: params[:user][:email])
      @user = User.new(name: mentor.name, email: mentor.email, activated: false, category: mentor.category, password: params[:user][:password], password_confirmation: params[:user][:password_confirmation])
      if @user.valid?
        @user.save
        UserMailer.account_activation(@user).deliver_now        
        flash.now[:info] = "確認メールを送りました。メールに含まれるURLをクリックしてアカウントを有効化してください。"
        redirect_to :root
      else
        flash.now[:danger] = @user.errors.full_messages.join(",")
        redirect_to :root
      end
    elsif params[:user][:account] && Member.where(account: params[:user][:account]).exists? 
      member = Member.find_by(account: params[:user][:account])
      @user = User.new(name: member.name, email: member.tsukuba_email, category: "student", activated: false, password: params[:user][:password], password_confirmation: params[:user][:password_confirmation])
      if @user.valid?
        @user.save
        UserMailer.account_activation(@user).deliver_now        
        flash.now[:info] = "確認メールを送りました。メールに含まれるURLをクリックしてアカウントを有効化してください。"
        redirect_to :root
      else
        flash.now[:danger] = @user.errors.full_messages.join(",")
      end
    else 
      flash.now[:danger] = "その学生番号は登録されていません。担当教員に問い合わせしてください。"
      redirect_to :root
    end
  end

  def logged_in
    unless logged_in? then
      redirect_to controller: 'users', action: 'login'
    end
  end  

  private 

end
