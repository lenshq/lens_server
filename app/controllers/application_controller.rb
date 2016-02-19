class ApplicationController < ActionController::Base
  include ActionController::Helpers
  include AuthHelper
  include Pundit
  helper_method :signed_in?, :current_user

  rescue_from Pundit::NotAuthorizedError do |exception|
    redirect_to root_url, alert: exception.message, status: :unauthorized
  end
end
