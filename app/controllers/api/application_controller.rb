class Api::ApplicationController < ApplicationController
  include AuthHelper
  helper_method :signed_in?, :current_user
  skip_before_filter :verify_authenticity_token

  def api_token
    request.headers["X-Auth-Token"] || params[:api_token]
  end

  def app_signed_in?
    current_app.present?
  end

  def current_app
    if api_token
      Application.find_by_token(api_token)
    end
  end

  def access_denied_response
    render json: { status: "error", message: "Not authorized" }, status: 403
  end

end

