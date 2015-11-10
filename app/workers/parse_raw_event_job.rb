class ParseRawEventJob < BaseJob
  def perform(raw_event_id)
    ProcessRawEvent.call(raw_event_id)
  end
end
