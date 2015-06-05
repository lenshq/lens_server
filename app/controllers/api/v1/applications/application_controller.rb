class Api::V1::Applications::ApplicationController < Api::V1::ApplicationController
  def application
    @application ||= current_user.participate_applications.find(params[:application_id])
  end
end
