class ScenarioFinder
  class << self
    def in_period(event_source, from: nil, to: nil)
      from ||= Time.now.utc - LensServer.config.graphs.period
      to ||= Time.now.utc

      query = Druid::Query::Builder.new
      #query.topn(:scenario, :duration, 100)
      query.group_by([:scenario])
      .granularity(:all)
      .filter(application: event_source.application.id)
      .filter(event_source: event_source.id)
      .long_sum(:count)
      .double_sum(:duration)
      .interval(from, to)

      # .first['result'].inject({}) do |acc, row|
      #   acc[row['scenario']] = {
      #     count: row['count'],
      #     duration: row['duration']
      requests_scenarios = get(query, :requests).inject({}) do |acc, row|
        acc[row['event']['scenario']] = {
          count: row['event']['count'],
          duration: row['event']['duration']
        }
        acc
      end

      get(query).inject({}) do |acc, row|
        acc[row['event']['scenario']] = {
          count: requests_scenarios[row['event']['scenario']][:count],
          duration: requests_scenarios[row['event']['scenario']][:duration]
        }
        acc
      end
    end

    private

    def datasource(type)
      "broker/#{LensServer.config.druid.datasource.send(type)}"
    end

    def get(query, type = :events)
      ServiceLocator.druid_client.data_source(datasource(type)).post(query)
    end
  end
end
