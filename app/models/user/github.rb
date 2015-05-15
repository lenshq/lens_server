class User::Github < ActiveRecord::Base
  belongs_to :user

  validates :uid, presence: true, uniqueness: true
end
