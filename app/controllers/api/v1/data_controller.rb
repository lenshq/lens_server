class Api::V1::DataController < Api::ApplicationController
  def rec
    if signed_in?
      if params[:data].blank?
        render json: {status: "error", msg: "no data was set"}, status: 422
      else
        current_app.rec_data(params[:data])
        render json: {status: "all ok"}
      end
    else
      render json: {status: "error", msg: "Invalid token, you are not authorized"}, status: 403
    end
  end
end

