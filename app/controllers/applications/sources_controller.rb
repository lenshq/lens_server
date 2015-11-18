class Applications::SourcesController < Applications::ApplicationController
  def show
    @application = application
    @event_source = application.event_sources.find(params[:id])

    scenarios = in_period(@event_source).inject({}) do |acc, row|
      acc[row['event']['scenario']] = {
        count: row['event']['count'],
        duration: row['event']['duration']
      }
      acc
    end
    @scenarios = @event_source.scenarios.where(events_hash: scenarios.keys).map do |scenario|
      { scenario.id => scenarios[scenario.events_hash] }
    end.sort_by {|k| -k.values.first[:duration] }
  end

  private

  def in_period(event_source, from: nil, to: nil)
    from ||= Time.now.utc - LensServer.config.graphs.period
    to ||= Time.now.utc

    query = Druid::Query::Builder.new
    query.group_by([:scenario])
      .granularity(:all)
      .filter(application: event_source.application.id)
      .filter(event_source: event_source.id)
      .long_sum(:count)
      .double_sum(:duration)
      .interval(from, to)

    get(query)
  end

  def datasource
    "broker/#{LensServer.config.druid.datasource.events}"
  end

  def get(query)
    ServiceLocator.druid_client.data_source(datasource).post(query)
  end
end
