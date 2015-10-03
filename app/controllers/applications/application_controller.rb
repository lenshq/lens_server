module Applications
  class ApplicationController < ::ApplicationController

    protected

    def application
      @application ||= current_user.applications.find_by(id: params[:application_id])
    end
  end
end
