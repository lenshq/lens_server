module Api
  module V1
    module Applications
      class SourcesController < Api::V1::Applications::ApplicationController
        def index
          filter_options = {}
          filter_options[:from_date] = Date.parse(params[:from])  if params[:from].present?
          filter_options[:to_date] = Date.parse(params[:to])      if params[:to].present?
          filter_options[:period] = params[:period]               if params[:period].present?

          sources = EventSourceFinder.new(application: application, filter_options: filter_options).get

          response.headers["Access-Control-Allow-Origin"] = "*"

          event_sources = sources[:event_sources].map do |es|
            {
              id: es.id,
              path: "#{es.source}##{es.endpoint}",
              duration: es.avg_duration(from: filter_options[:from_date], to: filter_options[:to_date]).round(2),
              time: es.sum_duration(from: filter_options[:from_date], to: filter_options[:to_date]).round(2),
              count: es.requests_count(from: filter_options[:from_date], to: filter_options[:to_date])
            }
          end.sort_by do |es|
            -(es[:duration] * es[:count])
          end

          render json: {
            event_sources: event_sources,
            requests: sources[:requests]
          }
        end
      end
    end
  end
end
