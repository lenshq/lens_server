class Api::V1::ApplicationsController < Api::V1::ApplicationController
  def stats
    if signed_in?
      @application = current_user.participate_applications.find(params[:id])

      if params[:date_from].empty?
        render json: {status: "error", message: "date_from must be set"}, status: 422
      elsif params[:date_to].empty?
        render json: {status: "error", message: "date_to must be set"}, status: 422
      else
        data = @application.run_query(params)
        render json: data
      end
    else
      access_denied_response
    end
  end
end
