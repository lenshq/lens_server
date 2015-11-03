class SessionsController < ApplicationController
  def new
  end

  def create
    if auth_hash
      user = RegisterGithubUser.call auth_hash
    else
      user = User.find_by(email: params[:session][:email].downcase)
    end

    if auth_hash || (user && user.authenticate(params[:session][:password]))
      sign_in user
      flash[:success] = t('flash.signed_in')
      redirect_to applications_path
    else
      flash.now[:error] = t('flash.authentication_error')
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end
end
