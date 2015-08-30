class User < ActiveRecord::Base
  has_many :application_users
  has_many :applications, through: :application_users
end
