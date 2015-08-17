class StoreRawEvent
  def initialize(application, data)
    @application = application
    @data = { data: data }
  end

  def call
    event = @application.raw_events.build(@data)
    if event.save
      # enqueue background task
    end
    event
  end

  def self.call(*args)
    new(*args).call
  end
end
