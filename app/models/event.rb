class Event < ActiveRecord::Base
  belongs_to :application
  belongs_to :request, counter_cache: true

  validates :request, presence: true
  validates :event_type, presence: true
  validates :duration, presence: true
  validates :position, presence: true, uniqueness: { scope: :request_id }
end
