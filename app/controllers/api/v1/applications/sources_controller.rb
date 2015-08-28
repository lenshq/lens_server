module Api
  module V1
    module Applications
      class SourcesController < Api::V1::Applications::ApplicationController
        def index
          sources = EventSourceFinder.new(application: application, filter_options: {}).get

          render json: { event_sources: sources[:event_sources], pages: sources[:pages] }, each_serializer: EventSourceSerializer
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
