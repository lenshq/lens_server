class ParseRawEventJob < BaseJob
  def perform(raw_event_id)
    re = RawEvent.find_by(id: raw_event_id)
    if re
      data = JSON.parse(re.data)
      parsed_data = Parser.new(data).parse

      meta = parsed_data[:meta]
      details = parsed_data[:details]

      application = re.application
      page = application.pages.create(controller: meta[:controller], action: meta[:action], duration: meta[:duration], raw_event_id: re.id)
      details.each_with_index do |row, index|
        page.events.create(event_type: row[:type],
                           content: row[:content],
                           duration: row[:duration],
                           position: index)
      end
    end
  end
end
