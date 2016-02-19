require 'rails_helper'
include AuthHelper

RSpec.describe ApplicationsController do
  let(:user) { create :user }
  let(:admin) { create :user, role: 'admin' }
  let(:user_application) { create :application }
  let(:admin_application) { create :application }

  render_views

  before do
    user.applications << user_application
    admin.applications << admin_application
  end

  describe 'get #INDEX' do
    subject { get :index }

    context 'if user' do
      before { sign_in user }

      it { is_expected.to be_success }
      it { is_expected.to have_http_status(200) }
    end

    context 'if admin' do
      before { sign_in admin }

      it { is_expected.to be_success }
      it { is_expected.to have_http_status(200) }
    end

    context 'if no user' do
      it { is_expected.to have_http_status(401) }
    end
  end

  describe 'post #CREATE' do
    let(:app_attrs) { { application: attributes_for(:application) } }
    subject { post :create, app_attrs }

    context 'if user' do
      before { sign_in user }

      it { expect { subject }.to change { Application.count }.by(1) }
    end

    context 'if admin' do
      before { sign_in admin }

      it { expect { subject }.to change { Application.count }.by(1) }
    end

    context 'if no user' do
      it { expect { subject }.to change { Application.count }.by(0) }
      it { is_expected.to have_http_status(401) }
    end
  end

  describe 'get #NEW' do
    subject { get :new }

    context 'if user' do
      before { sign_in user }
      it { expect(subject).to be_success }
      it { is_expected.to have_http_status(200) }
    end

    context 'if admin' do
      before { sign_in admin }
      it { expect(subject).to be_success }
      it { is_expected.to have_http_status(200) }
    end

    context 'if no user' do
      it { is_expected.to have_http_status(401) }
    end
  end

  describe 'get #SHOW' do
    def show_app(app)
      get :show, id: app.id
    end

    context 'if user' do
      before { sign_in user }

      it 'should show user app' do
        expect(show_app(user_application)).to have_http_status(200)
      end

      it 'should not show admin app' do
        expect(show_app(admin_application)).to have_http_status(401)
      end
    end

    context 'if admin' do
      before { sign_in admin }

      it 'should show user app' do
        expect(show_app(user_application)).to have_http_status(200)
      end

      it 'should show admin app' do
        expect(show_app(admin_application)).to have_http_status(200)
      end
    end

    context 'if no user' do
      it 'should not show user app' do
        expect(show_app(user_application)).to have_http_status(401)
      end

      it 'should not show admin app' do
        expect(show_app(admin_application)).to have_http_status(401)
      end
    end
  end

  describe 'post #DESTROY' do
    def destroy_app(app)
      post :destroy, id: app.id
    end

    context 'if user' do
      before { sign_in user }

      it 'should destroy user application' do
        expect { destroy_app(user_application) }.to change { Application.count }.by(-1)
      end

      it 'should not destroy admin application' do
        expect { destroy_app(admin_application) }.to change { Application.count }.by(0)
        expect(response).to have_http_status(401)
      end
    end

    context 'if admin' do
      before { sign_in admin }

      it 'should destroy user application' do
        expect { destroy_app(user_application) }.to change { Application.count }.by(-1)
      end

      it 'should destroy admin application' do
        expect { destroy_app(admin_application) }.to change { Application.count }.by(-1)
      end
    end

    context 'if no user' do
      it 'should not destroy user application' do
        expect { destroy_app(user_application) }.to change { Application.count }.by(0)
        expect(response).to have_http_status(401)
      end

      it 'should not destroy admin application' do
        expect { destroy_app(admin_application) }.to change { Application.count }.by(0)
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'post #UPDATE' do
    let(:app_attrs) { attributes_for(:application) }

    def check_update(app, shloud_be_eq)
      put :update, id: app.id, application: app_attrs
      app = Application.find(app.id)
      app_attrs.each do |k, v|
        if shloud_be_eq
          expect(app[k]).to eq(v)
        else
          expect(app[k]).not_to eq(v)
        end
      end
    end

    context 'if user' do
      before { sign_in user }

      it 'should update user application' do
        check_update(user_application, true)
      end

      it 'should not update admin application' do
        expect(put(:update, id: admin_application.id, application: app_attrs)).
          to have_http_status(401)
      end
    end

    context 'if admin' do
      before { sign_in admin }

      it 'should update user application' do
        check_update(user_application, true)
      end

      it 'should update admin application' do
        check_update(admin_application, true)
      end
    end

    context 'if no user' do
      it 'should not update user application' do
        expect(put(:update, id: user_application.id, application: app_attrs)).
          to have_http_status(401)
      end

      it 'should not update admin application' do
        expect(put(:update, id: admin_application.id, application: app_attrs)).
          to have_http_status(401)
      end
    end
  end
end
