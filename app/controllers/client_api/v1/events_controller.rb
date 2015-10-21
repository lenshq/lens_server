module ClientApi
  module V1
    class EventsController < ClientApi::V1::ApplicationController
      def create
        if application
          StoreRawEvent.call(application, params[:data].to_json)
          render json: { status: :ok }
        else
          head 401
        end
      end

      private

      def application
        @application ||= Application.find_by(token: api_token)
      end
    end
  end
end
