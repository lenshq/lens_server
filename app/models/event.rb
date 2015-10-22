# == Schema Information
#
# Table name: events
#
#  id          :integer          not null, primary key
#  page_id     :integer
#  event_type  :string
#  content     :text
#  duration    :float
#  position    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  started_at  :float
#  finished_at :float
#

class Event < ActiveRecord::Base
  belongs_to :application
  belongs_to :request, counter_cache: true

  validates :request, presence: true
  validates :event_type, presence: true
  validates :duration, presence: true
  validates :position, presence: true, uniqueness: { scope: :request_id }
end
