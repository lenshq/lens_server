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
  has_secure_password
  extend Enumerize

  enumerize :role, in: [:admin, :user], default: :user, predicates: true

  has_many :application_users
  has_many :applications, through: :application_users

  validates :email, presence: true

  before_create :generate_api_token
  before_save :downcase_email

  def downcase_email
    self.email = email.downcase
  end

  def generate_api_token
    self[:api_token] = SecureRandom.hex(24)
  end
end
