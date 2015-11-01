class StoreProcessedEvents
  def initialize(events)
    @events = events
  end

  def call
    messages = @events.map do |event|
      Poseidon::MessageToSend.new(LensServer.config.kafka.topic, event.to_json)
    end

    kafka_producer.send_messages(messages)
  end

  def self.call(*args)
    new(*args).call
  end

  def kafka_producer
    ServiceLocator.kafka_producer
  end
end
