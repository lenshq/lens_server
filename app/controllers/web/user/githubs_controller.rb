class Web::User::GithubsController < Web::User::NetworksController
  def callback
    user = services.github.register(auth_hash)
    reset_session
    sign_in user
    redirect_to :root
  end
end
