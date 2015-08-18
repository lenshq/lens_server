class Page < ActiveRecord::Base
  belongs_to :application
  has_many :events, dependent: :destroy

  validates :application, presence: true
  validates :controller, presence: true
  validates :action, presence: true
  validates :duration, presence: true
end
