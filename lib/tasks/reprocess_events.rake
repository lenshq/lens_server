namespace :events do
  desc 'Delete and reprocess all events (REALLY SLOW)'
  task reprocess: :environment  do
    EventSource.delete_all
    Page.delete_all
    Event.delete_all

    events_count = RawEvent.count
    batch_size = 1000

    puts "Processing #{events_count} raw events..."

    RawEvent.find_in_batches(batch_size: batch_size) do |group|
      group.each { |event| ParseRawEventJob.new.perform(event.id) }

      events_count -= batch_size
      events_count < 0 ? events_count = 0 : events_count
      puts "#{events_count} left..."
    end
  end
end
