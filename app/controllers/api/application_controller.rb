module Api
  class ApplicationController < ::ActionController::API
    before_action :authenticate!

    protected

    def authenticate!
      render json: { error: 'Unathorized' }, status: 401 unless current_user
    end

    def current_user
      @current_user ||= User.find_by(api_token: api_token)
    end

    def api_token
      @api_token ||= params[:api_token] || request.headers['X-Auth-Token']
    end
  end
end
