require 'rails_helper'

RSpec.describe Api::V1::Applications::EventsController do
  describe 'POST create' do
    let(:application) { create(:application, attributes_for(:application)) }
    let(:raw_event_attrs) { { application_id: application.token }.merge(attributes_for(:raw_event)) }
    subject { post :create, raw_event_attrs, format: :json }

    it { is_expected.to be_success }
    it { expect { subject }.to change { RawEvent.count }.by 1 }
  end
end
