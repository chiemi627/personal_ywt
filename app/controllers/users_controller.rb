class UsersController < ApplicationController
  before_action :logged_in, only:[:index]

  def new
    @user = User.new
  end

  def index
    @user = @current_user
  end

  def create
    @user = User.new(user_params)
    if @user.valid?
      @user.save
      UserMailer.account_activation(@user).deliver_now
      flash[:info] = "確認メールを送りました。メールに含まれるURLをクリックしてアカウントを有効化してください。"
      redirect_to :root
    else
      flash[:danger] = @user.errors.full_messages.join(",")
      redirect_to :users_new
    end
  end

  def logged_in
    unless logged_in? then
      redirect_to controller: 'users', action: 'login'
    end
  end  

  private

  def user_params
    params.require(:user).permit(:name, :email, :publish, :password, :password_confirmation)
  end

end
