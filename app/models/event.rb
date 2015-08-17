class Event < ActiveRecord::Base
  belongs_to :application

  validates :page, presence: true
  validates :event_type, presence: true
  validates :content, presence: true
  validates :duration, presence: true
  validates :position, presence: true, uniqueness: { scope: :page_id }
end
