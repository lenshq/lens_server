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
    event_source = find_or_create_event_source(raw_event)
    scenario = find_or_create_scenario(
      event_source: event_source,
      hash: generate_scenario_hash(raw_event.details)
    )
    raw_event.update(scenario: scenario)

    store_request(raw_event)
    store_events(raw_event)
  end

  def generate_scenario_hash(details)
    scenario_key = details.map { |d| d[:type] }.join
    Scenario.hash_from_string(scenario_key)
  end

  def find_or_create_event_source(raw_event)
    application = raw_event.application

    application.event_sources.find_or_create_by(
      source: raw_event.meta[:controller],
      endpoint: raw_event.meta[:action]
    )
  end

  def find_or_create_scenario(event_source:, hash:)
    event_source.scenarios.find_or_create_by(events_hash: hash)
  end

  def store_request(raw_event)
    request = Request.new(request_hash(raw_event)).to_json

    Commands::SendToKafka.call request
  end

  def store_events(raw_event)
    started_at = raw_event.details.first[:start]
    events = raw_event.details.each_with_index.map do |row, index|
      Event.new(
        event_hash(
          scenario: raw_event.scenario,
          details: row,
          meta: raw_event.meta,
          index: index,
          started_at: started_at
        )
      ).to_json
    end

    Commands::SendToKafka.call events
  end

  def request_hash(raw_event)
    scenario = raw_event.scenario
    event_source = scenario.event_source
    meta = raw_event.meta

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

  def base_hash(scenario:, meta:)
    @base_hash ||= {
      application: scenario.event_source.application.id,
      scenario: scenario.events_hash,
      controller: meta[:controller],
      action: meta[:action]
    }
  end

  def event_hash(scenario:, details:, meta:, index:, started_at:)
    base_hash(scenario: scenario, meta: meta).merge(
      timestamp: Time.at(details[:start]).to_s(:iso8601),
      event_type: details[:type],
      content: details[:content],
      duration: details[:duration],
      started_at: details[:start] - started_at,
      finished_at: details[:finish] - started_at,
      position: index
    )
  end
end
