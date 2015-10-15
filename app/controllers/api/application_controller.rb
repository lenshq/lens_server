module Api
  class ApplicationController < ::ActionController::API
    before_filter :authenticate!

    protected

    def authenticate!
      render json: { error: 'Unauthorized' }, status: 401 unless api_token
    end

    def api_token
      @api_token ||= params[:api_token] || request.headers['X-Auth-Token']
    end
  end
end
