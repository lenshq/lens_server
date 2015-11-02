module Commands
  class SendToKafka
    def initialize(messages)
      @messages = Array(messages)
    end

    def call
      prepared_messages = @messages.map do |message|
        Poseidon::MessageToSend.new(topic, message)
      end

      producer.send_messages prepared_messages
    end

    def self.call(*args)
      new(*args).call
    end

    private

    def topic
      LensServer.config.kafka.topic
    end

    def producer
      ServiceLocator.kafka_producer
    end
  end
end
