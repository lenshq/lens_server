class SignedApplicationController < ApplicationController
  after_action :verify_authorized
  before_action :authenticate!

  private

  def authenticate!
    redirect_to root_path, status: :unauthorized unless signed_in?
  end
end
