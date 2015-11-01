class Request
  include ActiveModel::Model

  attr_accessor :application, :scenario, :event_source, :controller, :action,
    :timestamp, :duration, :started_at, :finished_at, :raw_event

  class << self
    def sum_duration(event_source:, from:, to:)
      from ||= Time.now.utc - 1.week
      to ||= Time.now.utc

      query = Druid::Query::Builder.new
      query.double_sum(:duration).
        interval(from, to).
        granularity(:all).
        filter(event_source: event_source.id)

      result = get(query)

      result.first['result']['duration']
    end

    def avg_duration(event_source:, from:, to:)
      from ||= Time.now.utc - 1.week
      to ||= Time.now.utc

      query = Druid::Query::Builder.new

      query.double_sum(:duration).count(:count).
        interval(from, to).
        granularity(:all).
        filter(event_source: event_source.id).
        postagg { (duration / count).as avg }

      result = get(query)

      result.first['result']['avg']
    end

    def count(event_source:, from:, to:)
      from ||= Time.now.utc - 1.week
      to ||= Time.now.utc

      query = Druid::Query::Builder.new

      query.count(:count).
        interval(from, to).
        granularity(:all).
        filter(event_source: event_source.id)

      result = get(query)

      result.first['result']['count']
    end

    def by_application(application)
      from = Time.now.utc - 1.week
      to = Time.now.utc

      query = Druid::Query::Builder.new

      query.count(:duration).
        granularity(:minute).
        # group_by(:event_source).
        interval(from, to).
        filter(application: application.id)

      get(query)
    end

    private

    def datasource
      "broker/#{LensServer.config.druid.datasource.requests}"
    end

    def get(query)
      ServiceLocator.druid_client.data_source(datasource).post(query)
    end
  end
end
