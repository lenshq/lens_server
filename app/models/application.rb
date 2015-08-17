class Application < ActiveRecord::Base
  has_many :raw_events, dependent: :destroy

  validates :title, presence: true
  validates :token, presence: true, uniqueness: true

  before_validation :generate_token, on: :create

  protected

  def generate_token
    self[:token] = SecureRandom.hex(32)
  end
end
