module Applications
  class ApplicationController < SignedApplicationController
    after_action :verify_authorized

    protected

    def application
      @application ||= Application.find_by(id: params[:application_id])
      authorize @application
      @application
    end
  end
end
