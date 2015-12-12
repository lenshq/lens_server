module Api::V1
  class FollowersController < Api::V1::ApplicationController
    skip_before_action :authenticate!, only: [:create]

    def create
      follower = Follower.new(follower_params)
      if follower.save
        render json: follower
      else
        render json: follower.errors, status: :unprocessable_entity
      end
    end

    private

    def follower_params
      params.require(:follower).permit(:name, :email, :reason)
    end
  end
end
