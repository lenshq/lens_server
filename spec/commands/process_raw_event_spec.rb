require 'rails_helper'

RSpec.describe ProcessRawEvent do
  let(:raw_event) { create(:raw_event) }

  it 'process raw event command work and store final data' do
    klass = LensServer.config.service_locator.kafka_producer
    expect_any_instance_of(klass).to receive(:send_messages).twice
    ProcessRawEvent.call(raw_event.id)
  end
end
