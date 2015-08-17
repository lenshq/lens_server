module Api::V1::Applications
  class EventsController < Api::V1::Applications::ApplicationController
    def create
      event = application.raw_events.create(raw_event_params)
      render json: event
    end

    private

    def raw_event_params
      { data: params[:data].to_json }
    end
  end
end
