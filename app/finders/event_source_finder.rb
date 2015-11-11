class EventSourceFinder
  def initialize(application: nil, filter_options: {})
    raise ArgumentError.new('Application must be sended') if application.nil?

    @application = application
    @filter_options = default_filter_options #.merge(filter_options.with_indifferent_access)
  end

  def get
    {
      requests: requests,
      event_sources: event_sources
    }
  end

  private

  def event_sources
    event_sources_ids = data_from_druid.map { |r| r['event']['event_source'] }.uniq.compact
    @application.event_sources.where(id: event_sources_ids)
  end

  # [
  # {"version"=>"v1", "timestamp"=>"2015-11-10T18:48:00.000Z", "event"=>{"duration"=>14, "event_source"=>nil}},
  # {"version"=>"v1", "timestamp"=>"2015-11-10T18:48:00.000Z", "event"=>{"duration"=>1, "event_source"=>"11"}},
  # {"version"=>"v1", "timestamp"=>"2015-11-10T18:48:00.000Z", "event"=>{"duration"=>1, "event_source"=>"12"}},
  # {"version"=>"v1", "timestamp"=>"2015-11-10T18:48:00.000Z", "event"=>{"duration"=>1, "event_source"=>"13"}},
  # {"version"=>"v1", "timestamp"=>"2015-11-10T18:48:00.000Z", "event"=>{"duration"=>1, "event_source"=>"14"}},
  # {"version"=>"v1", "timestamp"=>"2015-11-10T18:48:00.000Z", "event"=>{"duration"=>1, "event_source"=>"15"}},
  # {"version"=>"v1", "timestamp"=>"2015-11-10T18:49:00.000Z", "event"=>{"duration"=>7, "event_source"=>nil}},
  # {"version"=>"v1", "timestamp"=>"2015-11-10T18:49:00.000Z", "event"=>{"duration"=>1, "event_source"=>"11"}},
  # {"version"=>"v1", "timestamp"=>"2015-11-10T18:49:00.000Z", "event"=>{"duration"=>1, "event_source"=>"12"}},
  # {"version"=>"v1", "timestamp"=>"2015-11-10T18:49:00.000Z", "event"=>{"duration"=>1, "event_source"=>"13"}},
  # {"version"=>"v1", "timestamp"=>"2015-11-10T18:54:00.000Z", "event"=>{"duration"=>4, "event_source"=>nil}},
  # {"version"=>"v1", "timestamp"=>"2015-11-10T18:54:00.000Z", "event"=>{"duration"=>1, "event_source"=>"11"}}
  # ]
  def requests
    grouped_by_date = data_from_druid.group_by do |row|
      row['timestamp']
    end

    grouped_by_date.map do |(date, entries)|
      {
        date: date,
        count: entries.inject(0) { |sum, e| sum + e['event']['count'] },
        event_source_ids: entries.map { |e| e['event']['event_source'] }.compact.map(&:to_i)
      }
    end
  end

  def data_from_druid
    @result ||= Request.by_application(@application)
  end

  def default_filter_options
    {
      from_date: 1.week.ago,
      to_date: Time.now,
      period: 'hour'
    }.with_indifferent_access
  end
end
