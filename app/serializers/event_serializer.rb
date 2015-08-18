class EventSerializer < ActiveModel::Serializer
  attributes :id, :event_type, :content, :duration, :position
end
