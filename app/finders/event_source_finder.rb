class EventSourceFinder
  def initialize(application: nil, filter_options: {})
    raise ArgumentError.new('Application must be sended') if application.nil?

    @application = application
    @filter_options = default_filter_options.merge(filter_options.with_indifferent_access)
  end

  def get
    {
      event_sources: event_sources,
      requests: requests
    }
  end

  private

  def event_sources
    sources = @application.event_sources
    filter_sources(sources)
  end

  def requests
    result = Request.by_application(@application)
    result.map do |row|
      { date: row['timestamp'], count: row['result']['duration'] }
    end
  end

  def default_filter_options
    {
      from_date: 1.week.ago,
      to_date: Time.now,
      period: 'hour'
    }.with_indifferent_access
  end

  def filter_sources(scope)
    scope.where(created_at: @filter_options[:from_date]..@filter_options[:to_date])
  end
end
