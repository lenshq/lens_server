class EventSourceFinder
  def initialize(application: nil, filter_options: {})
    raise ArgumentError.new('Application must be sended') if application.nil?

    @application = application
    @filter_options = default_filter_options.merge(filter_options.with_indifferent_access)
  end

  def get
    {
      event_sources: get_sources,
      requests: get_requests
    }
  end

  private

  def get_sources
    sources = @application.event_sources.includes(:requests)
    filter_sources(sources)
  end

  def get_requests
    sql = "
    SELECT d.date, COUNT(requests.id) FROM (
      SELECT * FROM generate_series(date_trunc('#{@filter_options[:period]}', '#{@filter_options[:from_date].to_s(:db)}'::timestamp with time zone),date_trunc('#{@filter_options[:period]}', '#{@filter_options[:to_date].to_s(:db)}'::text::date::timestamp with time zone), '1 #{@filter_options[:period]}') date_trunc(date)
    ) d LEFT JOIN requests ON date_trunc('#{@filter_options[:period]}', to_timestamp(requests.started_at)) = d.date GROUP BY d.date ORDER BY d.date ASC;
    "

    ActiveRecord::Base.connection.execute(sql).values.map {|k,v| { date: k, count: v} }
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
