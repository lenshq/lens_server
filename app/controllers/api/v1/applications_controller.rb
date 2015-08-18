module Api
  module V1
    class ApplicationsController < Api::V1::ApplicationController
      def index
        apps = Application.all
        render json: apps, each_serializer: ApplicationSerializer
      end

      def create
        app = Application.create application_params
        render json: app
      end

      def show
        app = Application.find params[:id]
        render json: app
      end

      private

      def application_params
        params.require(:application).permit(:title, :description, :domain)
      end
    end
  end
end
