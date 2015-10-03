class PageSerializer < ActiveModel::Serializer
  attributes :id, :application_id, :controller, :action, :duration, :events_count, :created_at, :updated_at, :raw_event_id, :event_source_id

  has_many :events
end
