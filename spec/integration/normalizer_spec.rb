require 'rails_helper'

RSpec.describe 'Normalizer' do
  def create_raw_event
    create :raw_event, data: File.read("#{Rails.root}/spec/fixtures/request_2.json"),
                       application: application
  end

  let(:application) { create :application }
  let(:raw_event) { create_raw_event }

  before do
    worker = ParseRawEventJob.new
    worker.perform raw_event.id
  end

  it 'should have no evens with not normalized params' do
    expect(Event.where('content LIKE ?', '%?,%').count).to eq(0)
  end
end
