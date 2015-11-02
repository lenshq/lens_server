class Event
  include ActiveModel::Model

  attr_accessor(
    :application, :scenario, :controller, :action, :timestamp, :event_type, :content, :duration,
    :position, :started_at, :finished_at
  )
end
