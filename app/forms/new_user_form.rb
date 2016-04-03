require 'reform/form/coercion'

class NewUserForm < Reform::Form
  property :email, type: String
  property :password, type: String
  property :password_confirmation, type: String, virtual: true

  validates :email, presence: true
  validates_uniqueness_of :email, case_sensitive: false
  validates :password, length: { minimum: 5, maximum: 120 }

  validate :password_confirmation_validation
  def password_confirmation_validation
    errors.add(:password, 'Password mismatch') if password != password_confirmation
  end

  def self.policy_class
    UserPolicy
  end
end
