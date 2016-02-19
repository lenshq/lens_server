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
    subject { get :show, id: application.id, format: :json }

    context 'if authorized' do
      context 'if user' do
        context 'if application belongs to user' do
          before { user.applications << application }

          it { is_expected.to be_success }
        end

        context 'if application doesn\'t belongs to user' do
          it { is_expected.to have_http_status(401) }
        end
      end

      context 'if admin' do
        before { user.update(role: :admin) }

        it { is_expected.to be_success }
      end
    end

    context 'if not authorized' do
      it { is_expected.to have_http_status(401) }
    end
  end
end
