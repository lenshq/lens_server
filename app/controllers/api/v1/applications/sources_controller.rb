module Api
  module V1
    module Applications
      class SourcesController < Api::V1::Applications::ApplicationController
        def index
          filter_options = {}
          filter_options[:from_date] = Date.parse(params[:from])  if params[:from].present?
          filter_options[:to_date] = Date.parse(params[:to])      if params[:to].present?
          filter_options[:period] = params[:period]              if params[:period].present?

          sources = EventSourceFinder.new(application: application, filter_options: filter_options).get

          response.headers["Access-Control-Allow-Origin"] = "*"

          render json: {
            event_sources: sources[:event_sources].sort_by { |es| -(es.time * es.pages_count) }.map { |es| EventSourceSerializer.new(es).as_json },
            pages: sources[:pages]
          }
        end

        def show
          source = application.event_sources.find params[:id]
          pages = source.pages

          #render json: pages, each_serializer: EventSourceSerializer
        end
      end
    end
  end
end
