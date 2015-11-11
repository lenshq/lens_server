# Rails.root are not initialized here
app_path = File.expand_path('../../', __FILE__)

config_path = File.join(app_path, 'config', 'lens.default.yml')
override_config_path = File.join(app_path, 'config', 'lens.yml')

secret_config_path = File.join(app_path, 'config', 'lens_secret.default.yml')
override_secret_config_path = File.join(app_path, 'config', 'lens_secret.yml')

Persey.init Rails.env do # set current environment
  source :yaml, config_path
  source :yaml, override_config_path
  source :yaml, secret_config_path, :secret
  source :yaml, override_secret_config_path, :secret

  env :default do
    service_locator do
      kafka_producer -> { Poseidon::Producer }
      druid_client -> { Druid::Client }
    end
  end

  env :production, parent: :default do
    # redeclare here some specific keys for production environment
  end

  env :development, parent: :production do
    # redeclare here some specific keys for development environment
  end

  env :staging, parent: :production do
    # redeclare here some specific keys for staging environment
  end

  env :test, parent: :development do
    service_locator do
      kafka_producer -> { Test::Poseidon::Producer }
      druid_client -> { Test::Druid::Client }
    end
  end
end
