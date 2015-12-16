module Applications
  class ApplicationController < SignedApplicationController
    protected

    def application
      @application ||= policy_scope(Application).find_by(id: params[:application_id])
    end
  end
end
