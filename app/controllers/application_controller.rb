class ApplicationController < ActionController::Base
  include ActionController::Helpers
  include AuthHelper
  include Pundit
  helper_method :signed_in?, :current_user
end
