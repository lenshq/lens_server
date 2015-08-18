class Page < ActiveRecord::Base
  belongs_to :application
  belongs_to :raw_event
  has_many :events, dependent: :destroy

  validates :application, presence: true
  validates :raw_event, presence: true
  validates :controller, presence: true
  validates :action, presence: true
  validates :duration, presence: true
end
