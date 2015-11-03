class Registration
  include ActiveModel::Model

  attr_accessor(
    :email,
    :password,
    :password_confirmation
  )

  validates :password, presence: true, length: { minimum: 8 }, confirmation: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }
  validate :unique_email_validator

  def register
    if valid?
      create_user
    end
  end

  def unique_email_validator
    if User.where(email: email.downcase).any?
      errors.add(:email, 'has already been taken')
    end
  end

  private

  def create_user
    User.create!(email: email.downcase, password: password, password_confirmation: password)
  end
end
