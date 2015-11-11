class Event
  include ActiveModel::Model

  attr_accessor(
    :application, :scenario, :controller, :action, :timestamp, :event_type, :content, :duration,
    :position, :started_at, :finished_at
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
    def find_by(application:, scenario:)
      query = Druid::Query::Builder.new
      query
      .group_by([:position, :event_type])
      .granularity(:all)
      .filter(application: application.id)
      .filter(scenario: scenario.events_hash)
      .long_sum(:count)
      .double_sum(:duration)
      .double_sum(:started_at)
      .double_sum(:finished_at)
      .postagg { (duration / count).as avg_duration }

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
