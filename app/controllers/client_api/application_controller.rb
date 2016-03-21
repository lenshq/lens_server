module ClientApi
  class ApplicationController < ::ActionController::API
    before_action :authenticate!

    protected

    def authenticate!
      render json: { error: t('error.unauthorized') }, status: 401 unless api_token
    end

    def api_token
      @api_token ||= params[:api_token] || request.headers['X-Auth-Token']
    end
  end
end
