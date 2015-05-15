class Web::User::NetworksController < Web::ApplicationController

  def failure
    redirect_to :root
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
