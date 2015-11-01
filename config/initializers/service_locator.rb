require 'service_locator'
require 'druid'

ServiceLocator.setup do |config|
  config.kafka_producer = lambda do
    LensServer.config.service_locator.kafka_producer.new(
      ["#{LensServer.config.kafka.host}:#{LensServer.config.kafka.port}"],
      'lens_bg_producer'
    )
  end

  config.druid_client = lambda do
    LensServer.config.service_locator.druid_client.new(
      "#{LensServer.config.zookeper.host}:#{LensServer.config.zookeper.port}/druid"
    )
  end
end
