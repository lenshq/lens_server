module Api
  module V1
    module Applications
      module Sources
        class ApplicationController < Api::V1::Applications::ApplicationController

          protected

          def event_source
            @event_source ||= application.event_sources.find(params[:source_id])
          end
        end
      end
    end
  end
end
