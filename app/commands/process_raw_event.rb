class ProcessRawEvent
  def self.call(*args)
    new(*args).call
  end

  def initialize(raw_event_id)
    @raw_event_id = raw_event_id
  end

  def call
    raw_event = RawEvent.find_by(id: @raw_event_id)
    return unless raw_event

    process_raw_event(raw_event)
  end

  private

  def process_raw_event(raw_event)
    application = raw_event.application
    parsed_raw_event = ParsedRawEvent.new(raw_event)

    meta = parsed_raw_event.meta
    details = parsed_raw_event.details
    scenario_hash = generate_scenario_hash(details)

    event_source = find_or_create_event_source(application: application, meta: meta)
    scenario = find_or_create_scenario(event_source: event_source, hash: scenario_hash)
    raw_event.scenario = scenario
    raw_event.save

    request = Request.new(
      request_hash(scenario: scenario, raw_event: raw_event, meta: meta)
    ).to_json
    Commands::SendToKafka.call request

    events = details.each_with_index.map do |row, index|
      Event.new(
        event_hash(scenario: scenario, details: row, meta: meta, index: index)
      ).to_json
    end
    Commands::SendToKafka.call events
  end

  def generate_scenario_hash(details)
    scenario_key = details.map { |d| d[:type] }.join
    Scenario.hash_from_string(scenario_key)
  end

  def find_or_create_event_source(application:, meta:)
    application.event_sources.find_or_create_by(source: meta[:controller], endpoint: meta[:action])
  end

  def find_or_create_scenario(event_source:, hash:)
    event_source.scenarios.find_or_create_by(events_hash: hash)
  end

  def base_hash(scenario:, meta:)
    @base_hash ||= {
      application: scenario.event_source.application.id,
      scenario: scenario.events_hash,
      controller: meta[:controller],
      action: meta[:action]
    }
  end

  def event_hash(scenario:, details:, meta:, index:)
    base_hash(scenario: scenario, meta: meta).merge(
      timestamp: Time.at(details[:start]).to_s(:iso8601),
      event_type: details[:type],
      content: details[:content],
      duration: details[:duration],
      started_at: details[:start],
      finished_at: details[:finish],
      position: index
    )
  end

  def request_hash(scenario:, raw_event:, meta:)
    event_source = scenario.event_source

    {
      timestamp: Time.at(meta[:start]).to_s(:iso8601),
      scenario: scenario.events_hash,
      event_source: event_source.id,
      application: event_source.application.id,
      controller: meta[:controller],
      action: meta[:action],
      duration: meta[:duration],
      started_at: meta[:start],
      finished_at: meta[:finish],
      raw_event: raw_event.id
    }
  end
end
