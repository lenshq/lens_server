class User < ActiveRecord::Base
  has_one :github, :dependent => :destroy, :autosave => true
  has_many :applications, :dependent => :destroy, :autosave => true

  has_many :application_users, dependent: :destroy
  has_many :participate_applications, through: :application_users, source: :application, class_name: Application

  def guest?
    false
  end

  def providers
    [self.github].compact
  end

  def email
    providers.first.try(:email)
  end

  def nickname
    providers.first.try(:nickname)
  end
end
