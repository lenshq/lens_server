require "rails_helper"

RSpec.describe "Scenarios" do
  def create_raw_event(num)
    create :raw_event, data: File.read("#{Rails.root}/spec/fixtures/request_#{num}.json"),
                       application: application
  end

  let(:application) { create :application }
  let(:raw_event_1) { create_raw_event 2 }
  let(:raw_event_2) { create_raw_event 3 }
  let(:raw_event_3) { create_raw_event 4 }

  before do
    worker = ParseRawEventJob.new
    worker.perform raw_event_1.id
    worker.perform raw_event_2.id
    worker.perform raw_event_3.id
  end

  it "pages scenario should be eq" do
    expect(raw_event_1.request.scenario).to eq(raw_event_2.request.scenario)
  end

  it "page scenario should not be eq" do
    expect(raw_event_1.request.scenario).not_to eq(raw_event_3.request.scenario)
  end
end
