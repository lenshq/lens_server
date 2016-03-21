require 'reform/form/coercion'

class UserForm < Reform::Form
  property :email, type: String
  property :password, type: String
  property :password_confirmation, type: String
  property :password_digest, type: String

  validates :password, presence: true,
                       length: {minimum: 5, maximum: 120},
                       on: :create
  validates :password, confirmation: true,
                       length: {minimum: 5, maximum: 120},
                       on: :update,
                       allow_blank: true

  def self.policy_class
    UserPolicy
  end
end
