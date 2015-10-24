require 'rails_helper'

RSpec.describe 'Events' do
  let(:application) { create(:application) }
  let(:raw_event)   { create(:raw_event) }

  before do
    worker = ParseRawEventJob.new
    worker.perform raw_event.id
  end

  it 'include BEGIN COMMIT transaction' do
    expect(raw_event.request.events.map(&:content)).to include 'BEGIN COMMIT transaction'
  end
end
