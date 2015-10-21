class User < ActiveRecord::Base
  has_many :application_users
  has_many :applications, through: :application_users

  before_create :generate_api_token

  def generate_api_token
    self[:api_token] = SecureRandom.hex(24)
  end
end
