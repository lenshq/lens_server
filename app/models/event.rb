class Event
  include ActiveModel::Model

  attr_accessor(
    :application, :scenario, :controller, :action, :timestamp, :event_type, :content, :duration,
    :event_source, :position, :started_at, :finished_at
  )

  class << self
    # {
    #   "content": null,
    #   "duration": 0.138118,
    #   "event_type": "read_fragment.action_controller",
    #   "finished_at": 1440509586.217381,
    #   "position": 90,
    #   "started_at": 1440509586.217243
    # },
    def find_by(application:, scenario: nil, event_source: nil)
      from ||= Time.now.utc - LensServer.config.graphs.period
      to ||= Time.now.utc

      query = Druid::Query::Builder.new
      query.interval(from, to)
      .granularity(:all)
      .filter(application: application.id)
      .long_sum(:count)
      .double_sum(:duration)
      .double_sum(:started_at)
      .double_sum(:finished_at)
      .postagg { (duration / count).as avg_duration }

      if scenario.present?
        query.filter(scenario: scenario.events_hash)
        query.group_by([:position, :event_type, :content])
      end

      if event_source.present?
        query.filter(event_source: event_source.id)
        query.group_by([:scenario, :position, :event_type, :content])
      end

      get(query)
    end

    def datasource
      "broker/#{LensServer.config.druid.datasource.events}"
    end

    def get(query)
      ServiceLocator.druid_client.data_source(datasource).post(query)
    end
  end
end
