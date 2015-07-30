Rails.application.config.middleware.use OmniAuth::Builder do
  credentials = Rails.application.config_for(:github)
  provider :github, credentials[:client_id], ENV['GITHUB_SECRET'], scope: 'user'
end

OmniAuth.config.logger = Rails.logger
