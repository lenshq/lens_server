# Rails.root are not initialized here
app_path = File.expand_path('../../', __FILE__)

config_path = File.join(app_path, 'config', 'lens.yml')

Persey.init Rails.env do # set current environment
  source :yaml, config_path

  env :default do
    # declare here some config option for all environments
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
    # redeclare here some specific keys for test environment
  end
end

# Define method in LensServer
module LensServer
  def self.config
    Persey.config
  end
end
