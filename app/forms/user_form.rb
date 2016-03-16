require 'reform/form/coercion'

class UserForm < Reform::Form
  property :email, type: String
  property :password, type: String
  property :password_confirmation, type: String

  validates :password, length: { in: 6..32 }, if: 'password.present?'

  def self.policy_class
    UserPolicy
  end
end
