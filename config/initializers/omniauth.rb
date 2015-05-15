Rails.application.config.middleware.use OmniAuth::Builder do
  configure do |c|
    c.path_prefix = LensServer.config.omniauth.path_prefix
  end

  provider :github, LensServer.config.auth_providers.github.app_id,
    LensServer.config.auth_providers.github.app_secret,
    scope: "user"
end
