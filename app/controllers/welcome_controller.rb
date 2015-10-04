class WelcomeController < ApplicationController
  layout 'landing'

  def index
    #redirect_to applications_path if signed_in?
  end
end
