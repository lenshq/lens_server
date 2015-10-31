class ApplicationController < ActionController::Base
  include ActionController::Helpers
  include AuthHelper
  helper_method :signed_in?, :current_user
end
