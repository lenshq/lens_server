require "rails_helper"

RSpec.describe "ProcessRawEventCommand" do
  let(:application) { create :application }
  let(:raw_event)   { create(:raw_event) }

  it "Process Raw Evnt Command work and store final data" do
    expect_any_instance_of(LensServer.config.service_locator.kafka_producer).to receive :send_messages
    ProcessRawEvent.call(raw_event.id)
  end

  it 'include BEGIN COMMIT transaction' do
    command = ProcessRawEvent.new(raw_event.id)
    details = command.parse_raw_data(raw_event)[:details]
    details_with_transactions = command.add_transactions_to_details(details)

    expect(details_with_transactions.map { |d| d[:content] }).to include 'BEGIN COMMIT transaction'
  end
end
