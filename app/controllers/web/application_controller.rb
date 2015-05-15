class Web::ApplicationController < ApplicationController
  include AuthHelper
  helper_method :signed_in?, :current_user
end
