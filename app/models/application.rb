class Application < ActiveRecord::Base
  validates :title, presence: true
end
