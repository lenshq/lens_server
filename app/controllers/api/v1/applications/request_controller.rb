class Api::V1::Applications::RequestController < Api::ApplicationController
  def index
    @requests = application.requests(params)
  end

  def application
    @application ||= current_user.participate_applications.find(params[:application_id])
  end
end
