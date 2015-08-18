module Api
  module V1
    module Applications
      class SourcesController < Api::V1::Applications::ApplicationController
        def index
          sources = application.event_sources

          render json: sources, each_serializer: EventSourceSerializer
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
