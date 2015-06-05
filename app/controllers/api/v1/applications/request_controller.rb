class Api::V1::Applications::RequestController < Api::ApplicationController
  def index
    @requests = application.requests(params)
    @data = @requests.map do |req|
      {
        id: req["id"],
        url: req["url"],
        datetime: req['datetim'],
        duration: req['duration']
      }
      render json: @data
    end
  end

  def application
    @application ||= current_user.participate_applications.find(params[:application_id])
  end
end
