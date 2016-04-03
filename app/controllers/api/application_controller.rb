module Api
  class ApplicationController < ::ActionController::API
    include Pundit
    before_action :authenticate!

    rescue_from Pundit::NotAuthorizedError do
      head 401
    end

    protected

    def authenticate!
      render json: { error: t('error.unauthorized') }, status: 401 unless current_user
    end

    def current_user
      @current_user ||= User.find_by(api_token: api_token)
    end

    def api_token
      @api_token ||= params[:api_token] || request.headers['X-Auth-Token']
    end
  end
end
