class StoreProcessedEvents
  def initialize(events)
    @events = events
  end

  def call
    messages = @events.map do |hash|
      Poseidon::MessageToSend.new(LensServer.config.kafka.topic, hash.to_json)
    end

    kafka_producer.send_messages(messages)
  end

  def self.call(*args)
    new(*args).call
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
end
