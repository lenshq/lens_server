Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github,
    LensServer.config.secret.github.client_id,
    LensServer.config.secret.github.secret,
    scope: 'user'
end

OmniAuth.config.logger = Rails.logger
