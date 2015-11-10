class Request
  include ActiveModel::Model

  attr_accessor(
    :application, :scenario, :event_source, :controller, :action, :timestamp, :duration,
    :started_at, :finished_at, :raw_event
  )

  class << self
    def sum_duration(event_source:, from:, to:)
      result = query_by_period(from, to) do |query|
        query.double_sum(:duration).
          granularity(:all).
          filter(event_source: event_source.id)
      end

      result.first['result']['duration']
    end

    def avg_duration(event_source:, from:, to:)
      result = query_by_period(from, to) do |query|
        query.double_sum(:duration).count(:count).
          granularity(:all).
          filter(event_source: event_source.id).
          postagg { (duration / count).as avg }
      end

      result.first['result']['avg']
    end

    def count(event_source:, from:, to:)
      result = query_by_period(from, to) do |query|
        query.count(:count).
          granularity(:all).
          filter(event_source: event_source.id)
      end

      result.first['result']['count']
    end

    def by_application(application)
      result = query_by_period do |query|
        query.count(:duration).
          granularity(:minute).
          group_by(:event_source).
          filter(application: application.id)
      end

      result
    end

    private

    def query_by_period(from: nil, to: nil)
      from ||= Time.now.utc - LensServer.config.graphs.period
      to ||= Time.now.utc

      query = Druid::Query::Builder.new
      yield query.interval(from, to)
      get(query)
    end

    def datasource
      "broker/#{LensServer.config.druid.datasource.requests}"
    end

    def get(query)
      ServiceLocator.druid_client.data_source(datasource).post(query)
    end
  end
end
