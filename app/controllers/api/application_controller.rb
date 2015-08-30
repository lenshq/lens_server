module Api
  class ApplicationController < ::ActionController::API

    protected

    def api_token
      @api_token ||= params[:api_token] || request.headers['X-Auth-Token']
    end
  end
end
