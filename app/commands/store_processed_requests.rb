class StoreProcessedRequests
  def initialize(requests)
    @requests = requests
  end

  def call
    messages = @requests.map do |request|
      Rails.logger.info request.to_json
      Poseidon::MessageToSend.new(LensServer.config.kafka.topic, request.to_json)
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
