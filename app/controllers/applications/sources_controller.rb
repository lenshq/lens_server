class Applications::SourcesController < Applications::ApplicationController
  def show
    @application = application
    @event_source = application.event_sources.find(params[:id])

    # scenarios = ScenarioFinder.in_period(@event_source)
    scenarios = ScenarioFinder.in_period(@event_source)

    @scenarios = @event_source.scenarios.where(events_hash: scenarios.keys).map do |scenario|
      { scenario.id => scenarios[scenario.events_hash] }
    end.sort_by {|k| -k.values.first[:duration] }
  end

end
