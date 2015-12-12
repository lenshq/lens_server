# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  email      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  name       :string
#  nickname   :string
#  image      :string
#  uid        :integer
#  token      :string
#  api_token  :string
#

class User < ActiveRecord::Base
  USER_ROLES = ['User', 'Admin']

  has_many :application_users
  has_many :applications, through: :application_users

  before_create :generate_api_token

  validates_inclusion_of :role, in: USER_ROLES

  def generate_api_token
    self[:api_token] = SecureRandom.hex(24)
  end

  def is_admin?
    role == 'Admin'
  end
end
