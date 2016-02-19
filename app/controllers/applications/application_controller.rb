module Applications
  class ApplicationController < SignedApplicationController

    protected

    def application
      @application ||= Application.find_by(id: params[:application_id])
      authorize @application
      @application
    end
  end
end
