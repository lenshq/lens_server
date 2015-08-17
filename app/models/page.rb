class Page < ActiveRecord::Base
  belongs_to :application

  validates :application, presence: true
  validates :controller, presence: true
  validates :action, presence: true
  validates :duration, presence: true
end
