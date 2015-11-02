require 'rails_helper'

RSpec.describe ProcessRawEvent do
  let(:raw_event) { create(:raw_event) }

  it 'process raw event command work and store final data' do
    klass = LensServer.config.service_locator.kafka_producer
    expect_any_instance_of(klass).to receive(:send_messages).twice
    ProcessRawEvent.call(raw_event.id)
  end

  it 'include BEGIN COMMIT transaction' do
    command = ProcessRawEvent.new(raw_event.id)
    details = command.parse_raw_data(raw_event)[:details]
    details_with_transactions = command.add_transactions_to_details(details)

    expect(details_with_transactions.map { |d| d[:content] }).to include 'BEGIN COMMIT transaction'
  end
end
