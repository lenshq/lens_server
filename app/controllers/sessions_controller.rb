class SessionsController < ApplicationController
  def create_from_github
    user = RegisterGithubUser.call auth_hash
    sign_in user
    flash[:success] = t('sessions.flash.create')
    redirect_to applications_path
  end

  def new
  end

  def create
    user = User.find_by(email: session_params[:email].downcase)
    if user && user.authenticate(session_params[:password])
      flash[:success] = t('sessions.flash.create')
      sign_in user
      redirect_to applications_url
    else
      flash.now[:danger] = t('sessions.flash.create_error')
      render 'new'
    end
  end

  def destroy
    if signed_in?
      sign_out
      flash[:success] = t('sessions.flash.destroy')
    end
    redirect_to root_url
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
