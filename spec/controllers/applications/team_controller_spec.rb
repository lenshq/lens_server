require 'rails_helper'
include AuthHelper

RSpec.describe Applications::TeamController do
  let(:user) { create :user }
  let(:admin) { create :user, role: 'admin' }
  let(:user_application) { create :application }
  let(:admin_application) { create :application }

  before do
    user.applications << user_application
    admin.applications << admin_application
  end

  context 'if not authorized' do
    it 'gets 401 for user application' do
      get :index, application_id: user_application.id
      expect(response).to have_http_status(401)
    end

    it 'gets 401 for user application' do
      get :index, application_id: admin_application.id
      expect(response).to have_http_status(401)
    end
  end

  context 'if authorized' do
    context 'if user' do
      before { sign_in user }

      it 'gets 200 for user application' do
        get :index, application_id: user_application.id
        expect(response).to have_http_status(200)
      end

      it 'gets 401 for admin application' do
        get :index, application_id: admin_application.id
        expect(response).to have_http_status(200)
      end
    end

    context 'is admin' do
      before { sign_in admin }

      it 'gets 200 for user application' do
        get :index, application_id: user_application.id
        expect(response).to have_http_status(200)
      end

      it 'gets 200 for admin application' do
        get :index, application_id: admin_application.id
        expect(response).to have_http_status(200)
      end
    end
  end
end
