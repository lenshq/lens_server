class ParseRawEventJob < BaseJob
  def perform(raw_event_id)
    re = RawEvent.find_by(id: raw_event_id)
    if re
      data = JSON.parse(re.data)
      parsed_data = Parser.new(data).parse

      meta = parsed_data[:meta]
      details = parsed_data[:details]

      application = re.application

      event_source = application.event_sources.find_by(source: meta[:controller], endpoint: meta[:action])
      event_source = application.event_sources.create(source: meta[:controller], endpoint: meta[:action]) if event_source.nil?

      page = application.pages.create(event_source_id: event_source.id,
                                      controller: meta[:controller],
                                      action: meta[:action],
                                      duration: meta[:duration],
                                      started_at: meta[:start],
                                      finished_at: meta[:finish],
                                      raw_event_id: re.id)

      details.each_with_index do |row, index|
        page.events.create(event_type: row[:type],
                           content: row[:content],
                           duration: row[:duration],
                           started_at: row[:start],
                           finished_at: row[:finish],
                           position: index)
      end
    end
  end
end
