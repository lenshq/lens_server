class SignedApplicationController < ApplicationController
  before_action :authenticate!

  private

  def authenticate!
    redirect_to root_path, status: :unauthorized unless signed_in?
  end
end
