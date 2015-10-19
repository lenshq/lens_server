class Application < ActiveRecord::Base
  has_many :application_users, dependent: :destroy
  has_many :collaborators, through: :application_users, source: :user
  has_many :raw_events, dependent: :destroy
  has_many :event_sources, dependent: :destroy
  has_many :requests, dependent: :destroy
  has_many :events, through: :requests

  validates :domain, presence: true, uniqueness: true
  validates :title, presence: true
  validates :token, presence: true, uniqueness: true

  before_validation :generate_token, on: :create

  protected

  def generate_token
    self[:token] = SecureRandom.hex(32)
  end
end
