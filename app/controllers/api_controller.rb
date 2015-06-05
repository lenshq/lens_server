class ApiController < ApplicationController
  def api_token
    request.headers["X-Auth-Token"] || params[:api_token]
  end

  def signed_in?
    current_app.present?
  end

  def current_app
    if api_token
      Application.find_by_token(api_token)
    end
  end

end

