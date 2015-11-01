# == Schema Information
#
# Table name: applications
#
#  id          :integer          not null, primary key
#  title       :string           not null
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  token       :string           not null
#  domain      :string
#

class Application < ActiveRecord::Base
  has_many :application_users, dependent: :destroy
  has_many :collaborators, through: :application_users, source: :user
  has_many :raw_events, dependent: :destroy
  has_many :event_sources, dependent: :destroy

  validates :domain, presence: true, uniqueness: true
  validates :title, presence: true
  validates :token, presence: true, uniqueness: true

  before_validation :generate_token, on: :create

  def requests

  end

  def events

  end

  protected

  def generate_token
    self[:token] = SecureRandom.hex(32)
  end
end
