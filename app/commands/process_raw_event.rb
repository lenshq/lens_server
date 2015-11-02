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

  # NOTE: not private because it user in the unit test.
  # TODO: refactor this method and test and move it to private section
  def add_transactions_to_details(details)
    position = nil

    details.each_with_object({}).with_index do |(row, memo), index|
      case row[:content]
      when transaction_begin?
        memo[:type] = row[:type]
        memo[:start] = row[:start]
        position = index
      when transaction_end?
        if position
          memo[:content] = "BEGIN #{row[:content]} transaction"
          memo[:finish] = row[:finish]
          memo[:duration] = ((memo[:finish] - memo[:start]) * 1000)
          details.insert(position, memo.dup)
          memo.clear
          position = nil
        end
      end
    end

    details
  end

  # NOTE: not private because it user in the unit test.
  # TODO: refactor this method and test and move it to private section
  def parse_raw_data(raw_event)
    data = JSON.parse(raw_event.data)
    Parser.new(data).parse
  end

  private

  def process_raw_event(raw_event)
    application = raw_event.application

    parsed_data = parse_raw_data(raw_event)

    meta = parsed_data[:meta]
    details = parsed_data[:details]
    details = add_transactions_to_details(details)
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

  def generate_scenario_hash(details)
    scenario_key = details.map { |d| d[:type] }.join
    Scenario.hash_from_string(scenario_key)
  end

  def transaction_begin?
    ->(content) { content == 'BEGIN' }
  end

  def transaction_end?
    ->(content) { %w(ROLLBACK COMMIT).include? content }
  end
end
