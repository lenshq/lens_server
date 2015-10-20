require 'rails_helper'

RSpec.describe Api::V1::ApplicationsController do
  let(:user) { create :user }

  before(:each) do
    api_token user.api_token
  end

  describe 'GET index' do
    subject { get :index, format: :json }

    it { is_expected.to be_success }
  end

  describe 'POST create' do
    let(:app_attrs) { { application: attributes_for(:application) } }
    subject { post :create, app_attrs, format: :json }

    it { is_expected.to be_success }
    it { expect { subject }.to change { Application.count }.by 1 }
  end

  describe 'GET show' do
    let(:application) { create :application }
    before { user.applications << application }
    subject { get :show, id: application.id, format: :json }

    it { is_expected.to be_success }
  end
end
