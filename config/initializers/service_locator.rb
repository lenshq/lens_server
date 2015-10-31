require 'service_locator'

SerivceLocator.setup do |config|
  config.kafka_producer = lambda do
    LensServer.config.service_locator.kafka_producer.new(
      ["#{LensServer.config.kafka.host}:#{LensServer.config.kafka.port}"],
      'lens_bg_producer'
    )
  end
end
