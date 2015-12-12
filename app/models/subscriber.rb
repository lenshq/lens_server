class Subscriber < ActiveRecord::Base
  validates :email,
    presence: true,
    uniqueness: true,
    format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }

  def email=(email)
    self[:email] = email.downcase
  end
end
