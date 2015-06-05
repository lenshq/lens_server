class Api::V1::Applications::RequestsController < Api::ApplicationController
  def index
    @requests = application.requests(params)
    @data = @requests.map do |req|
      {
        id: req["id"],
        url: req["url"],
        datetime: req['datetime'],
        duration: req['duration']
      }
    end
    render json: @data
  end

  def show
    @request = application.requests(params).first
    @data = {
      id: @request["id"],
      url: @request["url"],
      datetime: @request['datetime'],
      duration: @request['duration'],
      records: JSON.load(@request['data'])
    }
    render json: @data
  end

  def application
    @application ||= current_user.participate_applications.find(params[:application_id])
  end
end
