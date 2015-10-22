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

class EventSerializer < ActiveModel::Serializer
  attributes :id, :event_type, :content, :duration, :position
end
