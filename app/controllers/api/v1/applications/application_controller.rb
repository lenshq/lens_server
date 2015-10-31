module Api
  module V1
    module Applications
      class ApplicationController < Api::V1::ApplicationController

        protected

        def application
          @application ||= current_user.applications.find(params[:application_id])
        end
      end
    end
  end
end
