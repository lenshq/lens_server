class SessionsController < ApplicationController
  def create
    user = RegisterGithubUser.call auth_hash
    sign_in user
    redirect_to root_url(port: 3001)
  end
end
