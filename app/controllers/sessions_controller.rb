class SessionsController < ApplicationController
  def create
    user = RegisterGithubUser.call auth_hash
    sign_in user
    redirect_to applications_path
  end
end
