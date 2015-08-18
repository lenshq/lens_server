source 'https://rubygems.org'

gem 'rails', '4.2.1'
gem 'rails-api'
gem 'active_model_serializers', '= 0.10.0rc2' # TODO: fix it after release!

gem 'pg'

gem 'unicorn'
gem 'omniauth-github'
gem 'pg_query'

# State machine
gem 'aasm'

gem 'sidekiq'

group :development, :test do
  gem 'pry-rails'
  gem 'pry-byebug'
end

group :test do
  gem 'simplecov', require: false
  gem 'database_cleaner'
  gem 'rspec-rails', '~> 3.0'
  gem "factory_girl_rails"
end
