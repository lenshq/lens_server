module Api::V1::Applications
  class EventsController < Api::V1::Applications::ApplicationController
    def create
      event = StoreRawEvent.call(application, params[:data].to_json)
      render json: event
    end
  end
end
