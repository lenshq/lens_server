require 'rails_helper'

RSpec.describe Api::V1::EventsController do
  describe 'POST create with api_token' do
    let(:application) { create(:application, attributes_for(:application)) }
    let(:raw_event_attrs) { { api_token: application.token }.merge(attributes_for(:raw_event)) }
    subject { post :create, raw_event_attrs, format: :json }

    it { is_expected.to be_success }
    it { expect { subject }.to change { RawEvent.count }.by 1 }
  end

  describe 'POST create with headers' do
    let(:application) { create(:application, attributes_for(:application)) }
    let(:raw_event_attrs) { attributes_for(:raw_event) }
    subject do
      @request.headers['X-Auth-Token'] = application.token
      post :create, raw_event_attrs, { format: :json }
    end

    it { is_expected.to be_success }
    it { expect { subject }.to change { RawEvent.count }.by 1 }
  end
end
