source 'https://rubygems.org'

gem 'rails', '4.2.5'
gem 'rails-api'
gem 'active_model_serializers', '= 0.10.0rc2' # TODO: fix it after release!

gem 'pg'

gem 'jquery-rails'
gem 'sass-rails'
gem 'uglifier'
gem 'therubyracer'
gem 'oj'

gem 'unicorn'
gem 'omniauth-github'
gem 'pg_query'
gem 'haml-rails'
gem 'bootstrap-sass'
gem 'bootstrap-material-design'
gem 'premailer-rails'

# State machine
gem 'aasm'

gem 'sidekiq'
gem 'sinatra', require: false

gem 'rails-i18n', '~> 4.0.0'

gem 'poseidon'   # kafka
gem 'ruby-druid' , github: 'lenshq/ruby-druid'

# Configuration
gem 'persey', '>= 0.0.8'
gem 'rollbar', '~> 2.4.0'

gem 'lz4-ruby'

gem 'enumerize'

group :development do
  gem 'pry-rails'
  gem 'annotate'
end

group :test do
  gem 'simplecov', require: false
  gem 'codeclimate-test-reporter', require: false
  gem 'database_cleaner'
  gem 'rspec-rails', '~> 3.0'
  gem 'factory_girl_rails'
end

group :test, :development do
  gem 'byebug'
  gem 'pry-byebug'
end
