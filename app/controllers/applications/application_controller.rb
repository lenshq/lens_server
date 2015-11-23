module Applications
  class ApplicationController < ::ApplicationController
    before_action :authenticate!

    protected

    def application
      @application ||= current_user.applications.find_by(id: params[:application_id])
    end

    def authenticate!
      redirect_to applications_path unless signed_in?
    end
  end
end
