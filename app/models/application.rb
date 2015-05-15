class Application < ActiveRecord::Base
  belongs_to :user

  validates :domain, presence: true, uniqueness: true
  validates :token, presence: true, uniqueness: true
  validates :title, presence: true
end
