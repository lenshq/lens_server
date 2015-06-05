class Api::V1::Applications::RequestsController < Api::V1::Applications::ApplicationController
  def index
    if signed_in?
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
    else
      access_denied_response
    end
  end

  def show
    if signed_in?
      @request = application.requests(params).first
      data = JSON.load(@request['data'])
      records = data.delete(:records)
      @data = {
        id: @request["id"],
        url: @request["url"],
        datetime: @request['datetime'],
        duration: @request['duration'],
        records: records,
        data: data
      }
      render json: @data
    else
      access_denied_response
    end
  end

  def create
    if app_signed_in?
      if params[:data].blank?
        render json: {status: "error", message: "No Data was set"}, status: 422
      else
        current_app.rec_data(params[:data])
        render json: {status: "success", message: "Record created"}
      end
    else
      access_denied_response
    end
  end
end
