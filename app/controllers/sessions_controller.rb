class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password]) && user.activated?
      log_in user
      redirect_to :root
    else
      flash.now[:danger] = 'アカウントが有効になっていないか、アカウント・パスワードがあっていません' 
      render 'new'
    end
  end

  def logged_in?
    !current_user.nil?
  end

  def destroy
    log_out
    redirect_to :root
  end
end
