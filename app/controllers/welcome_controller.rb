class WelcomeController < ApplicationController
  layout 'landing'

  def index
    @follower = Follower.new
    redirect_to applications_path if signed_in?
  end
end
