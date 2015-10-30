class ParseRawEventJob < BaseJob
  def perform(raw_event_id)
    re = RawEvent.find_by(id: raw_event_id)
    if re
      data = JSON.parse(re.data)
      parsed_data = Parser.new(data).parse

      meta = parsed_data[:meta]
      details = parsed_data[:details]
      details = add_transactions_to_details(details)

      application = re.application

      event_source = application.event_sources.find_or_create_by(source: meta[:controller],
                                                                 endpoint: meta[:action])

      hash = Scenario.hash_from_string(details.inject("") { |a, d| a << d[:type] })
      scenario = event_source.scenarios.find_or_create_by(events_hash: hash)

      scenario.requests.create(
        event_source_id: event_source.id,
        application_id: application.id,
        controller: meta[:controller],
        action: meta[:action],
        duration: meta[:duration],
        started_at: meta[:start],
        finished_at: meta[:finish],
        raw_event_id: re.id
      )

      producer = Poseidon::Producer.new(
        ["#{LensServer.config.kafka.host}:#{LensServer.config.kafka.port}"],
        "lens_bg_producer"
      )

      base_hash = {
        application: application.id,
        scenario: scenario.event_hash,
        conroller: meta[:controller],
        action: meta[:action]
      }

      messages = []
      details.each_with_index do |row, index|
        hash = base_hash.merge({
          timestamp: Time.at(row[:start]).to_s(:iso8601),
          event_type: row[:type],
          content: row[:content],
          duration: row[:duration],
          started_at: row[:start],
          finished_at: row[:finish],
          position: index
        })
        messages << Poseidon::MessageToSend.new("lens_test", hash.to_json)
      end
      producer.send_messages(messages)
    end
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
