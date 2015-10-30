class ProcessRawEvent
  def self.call(*args)
    new(*args).call
  end

  def initialize(raw_event_id)
    @raw_event_id = raw_event_id
  end

  def call
    raw_event = RawEvent.find_by(id: @raw_event_id)
    process_raw_event(raw_event) if raw_event.present?
  end

  def process_raw_event(raw_event)
    application = raw_event.application

    parsed_data = parse_raw_data(raw_event)

    meta = parsed_data[:meta]
    details = parsed_data[:details]
    details = add_transactions_to_details(details)
    scenario_hash = generate_scenario_hash(details)

    event_source = find_or_create_event_source(application: application, meta: meta)
    scenario = find_or_create_scnario(event_source: event_source, hash: scenario_hash)
    create_request(scenario: scenario, raw_event: raw_event, meta: meta)

    events = details.each_with_index.map do |row, index|
      event_hash(scenario: scenario, details: row, meta: meta, index: index)
    end

    store_events(events)
  end

  def store_events(events)
    messages = events.map do |hash|
      Poseidon::MessageToSend.new(LensServer.config.kafka.topic, hash.to_json)
    end

    kafka_producer.send_messages(messages)
  end

  def parse_raw_data(raw_event)
    data = JSON.parse(raw_event.data)
    Parser.new(data).parse
  end

  def find_or_create_event_source(application:, meta:)
    application.event_sources.find_or_create_by(source: meta[:controller], endpoint: meta[:action])
  end

  def find_or_create_scnario(event_source:, hash:)
    event_source.scenarios.find_or_create_by(events_hash: hash)
  end

  def create_request(scenario:, raw_event:, meta:)
    event_source = scenario.event_source

    scenario.requests.create(
      event_source_id: event_source.id,
      application_id: event_source.application.id,
      controller: meta[:controller],
      action: meta[:action],
      duration: meta[:duration],
      started_at: meta[:start],
      finished_at: meta[:finish],
      raw_event_id: raw_event.id
    )
  end

  def generate_scenario_hash(details)
    Scenario.hash_from_string(details.inject('') { |a, d| a << d[:type] })
  end

  def kafka_producer
    @producer ||= begin
                    klass = LensServer.config.service_locator.kafka_producer
                    klass.new(
                      ["#{LensServer.config.kafka.host}:#{LensServer.config.kafka.port}"],
                      'lens_bg_producer'
                    )
                  end
  end

  def base_hash(scenario:, meta:)
    @base_hash ||=
      {
        application: scenario.event_source.application.id,
        scenario: scenario.events_hash,
        conroller: meta[:controller],
        action: meta[:action]
      }
  end

  def event_hash(scenario:, details:, meta:, index:)
    base_hash(scenario: scenario, meta: meta).merge({
      timestamp: Time.at(details[:start]).to_s(:iso8601),
      event_type: details[:type],
      content: details[:content],
      duration: details[:duration],
      started_at: details[:start],
      finished_at: details[:finish],
      position: index
    })
  end

  def add_transactions_to_details(details)
    position = nil
    details.each_with_object({}).with_index do |(row, memo), index|
      case row[:content]
      when transaction_begin?
        memo[:type] = row[:type]
        memo[:start] = row[:start]
        position = index
      when transaction_end?
        memo[:content] = "BEGIN #{row[:content]} transaction"
        memo[:finish] = row[:finish]
        memo[:duration] = ((memo[:finish] - memo[:start]) * 1000)
        details.insert(position, memo) if position
        position = nil
      end
    end
    details
  end

  def transaction_begin?
    ->(content) { content == 'BEGIN' }
  end

  def transaction_end?
    ->(content) { %w(ROLLBACK COMMIT).include? content }
  end
end
