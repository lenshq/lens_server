module Api
  module V1
    module Applications
      class ApplicationController < Api::V1::ApplicationController

        protected

        def application
          @application ||= Application.find_by(token: api_token)
        end
      end
    end
  end
end
