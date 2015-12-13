class Subscriber < ActiveRecord::Base
  include AASM

  validates :email,
    presence: true,
    uniqueness: true,
    format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }

  before_validation :generate_unsubscription_token, :generate_verification_token

  aasm do
    state :new, initial: true
    state :confirmed
    state :unsubscribed

    event :confirm do
      transitions from: :new, to: :confirmed
    end

    event :unsubscribe do
      transitions from: :confirmed, to: :unsubscribed
    end
  end

  def email=(email)
    self[:email] = email.downcase
  end

  private

  def generate_unsubscription_token
    self[:unsubscription_token] = SecureRandom.hex(32)
  end

  def generate_verification_token
    self[:verification_token] = SecureRandom.hex(32)
  end
end
