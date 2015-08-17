module Api::V1::Applications
  class ApplicationController < ::ApplicationController

    protected

    def application
      @application ||= Application.find_by(token: params[:application_id] || params[:id])
    end
  end
end
