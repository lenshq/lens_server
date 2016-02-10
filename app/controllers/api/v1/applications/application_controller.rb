module Api
  module V1
    module Applications
      class ApplicationController < Api::V1::ApplicationController

        protected

        def application
          @application ||= Application.find(params[:application_id])
          authorize @application
          @application
        end
      end
    end
  end
end
