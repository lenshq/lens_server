class StoreRawEvent
  def initialize(application, data)
    @application = application
    @data = { data: data }
  end

  def call
    event = @application.raw_events.build(@data)
    ParseRawEventJob.perform_async(event.id) if event.save
    event
  end

  def self.call(*args)
    new(*args).call
  end
end
