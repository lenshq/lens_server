class Event < ActiveRecord::Base
  belongs_to :application
  belongs_to :page, counter_cache: true

  validates :page, presence: true
  validates :event_type, presence: true
  validates :duration, presence: true
  validates :position, presence: true, uniqueness: { scope: :page_id }
end
