ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/rg"

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  #
  #
  def generate_fake_event_data
    {
      data: {
          action: "show", controller: "posts",
          params: {id: "123", msg: "test evt"},
          url: "/posts/123",
          time: Time.now,
          duration: 300,
          records: [],
          method: "GET",
          meta: {client_version: 123}
        }
    }
  end
end
