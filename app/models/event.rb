class Event
  include ActiveModel::Model

  attr_accessor :application, :scenario, :controller, :action,
    :timestamp, :event_type, :content, :duration, :position,
    :started_at, :finished_at

  class << self
    def avg_duration
      query = Druid::Query.new("#{LensServer.config.kafka.topic}/events").long_sum('duration')

      ServiceLocator.druid_client.send(query)
    end

    def test
      query = Druid::Query.new("#{LensServer.config.kafka.topic}/events").
        group_by('duration')

      ServiceLocator.druid_client.send(query)
    end
  end
end
