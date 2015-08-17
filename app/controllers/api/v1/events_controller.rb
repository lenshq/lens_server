module Api
  module V1
    class EventsController < Api::V1::ApplicationController
      def create
        event = StoreRawEvent.call(application, params[:data].to_json)
        render json: event
      end

      private

      def application
        @application ||= Application.find_by(token: api_token)
      end
    end
  end
end
