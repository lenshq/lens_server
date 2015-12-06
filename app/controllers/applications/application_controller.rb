module Applications
  class ApplicationController < SignedApplicationController
    protected

    def application
      @application ||= current_user.applications.find_by(id: params[:application_id])
    end
  end
end
