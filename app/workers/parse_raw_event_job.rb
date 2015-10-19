class ParseRawEventJob < BaseJob
  def perform(raw_event_id)
    re = RawEvent.find_by(id: raw_event_id)
    if re
      data = JSON.parse(re.data)
      parsed_data = Parser.new(data).parse

      meta = parsed_data[:meta]
      details = parsed_data[:details]

      application = re.application

      event_source = application.event_sources.find_or_create_by(source: meta[:controller],
                                                                 endpoint: meta[:action])

      hash = Scenario.hash_from_string(details.inject("") { |a, d| a << d[:type] })
      scenario = event_source.scenarios.find_or_create_by(events_hash: hash)

      new_request = scenario.requests.create(
        event_source_id: event_source.id,
        application_id: application.id,
        controller: meta[:controller],
        action: meta[:action],
        duration: meta[:duration],
        started_at: meta[:start],
        finished_at: meta[:finish],
        raw_event_id: re.id
      )

      details.each_with_index do |row, index|
        new_request.events.create(
          event_type: row[:type],
          content: row[:content],
          duration: row[:duration],
          started_at: row[:start],
          finished_at: row[:finish],
          position: index
        )
      end
    end
  end
end
