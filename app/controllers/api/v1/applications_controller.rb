module Api
  module V1
    class ApplicationsController < Api::V1::ApplicationController
      before_filter :authenticate!

      def index
        apps = current_user.applications.all
        render json: apps, each_serializer: ApplicationSerializer
      end

      def create
        app = current_user.applications.create application_params
        render json: app
      end

      def show
        app = current_user.applications.find params[:id]
        render json: app
      end

      private

      def application_params
        params.require(:application).permit(:title, :description, :domain)
      end

      def authenticate!
        render json: { error: 'Unathorized' }, status: 401 unless current_user
      end

      def current_user
        @current_user ||= User.find_by token: api_token
      end
    end
  end
end
