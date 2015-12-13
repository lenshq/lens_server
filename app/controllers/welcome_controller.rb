class WelcomeController < ApplicationController
  layout 'landing'

  def index
    @subscriber = Subscriber.new
    redirect_to applications_path if signed_in?
  end
end
