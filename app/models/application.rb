class Application < ActiveRecord::Base
  belongs_to :user
  has_many :application_users, dependent: :destroy
  has_many :colleagues, through: :application_users, source: :user, class_name: User

  validates :domain, presence: true, uniqueness: true
  validates :token, presence: true, uniqueness: true
  validates :title, presence: true
end
