module Api
  module V1
    class SubscribersController < Api::V1::ApplicationController
      skip_before_action :authenticate!, only: [:create]

      def create
        subscriber = Subscriber.new(follower_params)
        if subscriber.save
          render json: subscriber
        else
          render json: subscriber.errors, status: :unprocessable_entity
        end
      end

      private

      def follower_params
        params.require(:subscriber).permit(:name, :email, :reason)
      end
    end
  end
end
