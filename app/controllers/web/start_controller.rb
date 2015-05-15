class Web::StartController < Web::ApplicationController
  def index
    redirect_to applications_path if signed_in?
  end
end
