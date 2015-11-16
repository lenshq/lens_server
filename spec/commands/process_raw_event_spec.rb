require 'rails_helper'

RSpec.describe ProcessRawEvent do
  let(:raw_event) { create(:raw_event) }
  let(:producer) { ServiceLocator.kafka_producer }

  it 'process raw event command work and store final data' do
    klass = LensServer.config.service_locator.kafka_producer
    expect_any_instance_of(klass).to receive(:send_messages).twice
    ProcessRawEvent.call(raw_event.id)
  end

  it 'correct calculate start and finish time in events' do
    producer.clear
    ProcessRawEvent.call(raw_event.id)
    messages = producer.messages.flatten.map { |message| JSON.parse(message.value) }
    events_messages = messages.map { |hash| hash if hash['controller'] }.compact
    sorted_events_messages = events_messages.sort_by { |k| k['started_at'] }
    first_event = sorted_events_messages.first
    expect(first_event['started_at']).to eq 0
    expect(first_event['finished_at'] - first_event['started_at']).to be_within(0.001).of(first_event['duration'])
  end
end
