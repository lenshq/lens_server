require 'rails_helper'

RSpec.describe ApplicationsController do
  let(:user) { create :user }
  let(:admin) { create :user, role: 'admin' }
  let(:user_application) { create :application }
  let(:admin_application) { create :application }

  render_views

  before { user.applications << user_application; admin.applications << admin_application }

  def sign_in_user
    session[:user_id] = user.id
  end

  def sign_in_admin
    session[:user_id] = admin.id
  end

  describe 'get #INDEX' do
    subject { get :index }

    context 'if user' do
      before { sign_in_user }
      it { is_expected.to be_success }
      it { is_expected.to have_http_status(200) }
    end

    context 'if admin' do
      before { sign_in_admin }
      it { is_expected.to be_success }
      it { is_expected.to have_http_status(200) }
    end

    context 'if no user' do
      it { is_expected.to have_http_status(302) }
    end
  end

  describe 'post #CREATE' do
    let(:app_attrs) { { application: attributes_for(:application) } }
    subject { post :create, app_attrs }

    context 'if user' do
      before { sign_in_user }
      it { expect { subject }.to change { Application.count }.by(1) }
    end

    context 'if admin' do
      before { sign_in_admin }
      it { expect { subject }.to change { Application.count }.by(1) }
    end

    context 'if no user' do
      it { expect { subject }.to change { Application.count }.by(0) }
    end
  end

  describe 'get #NEW' do
    subject { get :new }

    context 'if user' do
      before { sign_in_user }
      it { expect(subject).to be_success }
      it { is_expected.to have_http_status(200) }
    end

    context 'if admin' do
      before { sign_in_admin }
      it { expect(subject).to be_success }
      it { is_expected.to have_http_status(200) }
    end

    context 'if no user' do
      it { expect(subject).not_to be_success }
      it { is_expected.to have_http_status(302) }
    end
  end

  describe 'get #SHOW' do
    def show_app(app)
      get :show, id: app.id
    end

    context 'if user' do
      before { sign_in_user }

      it 'should show user app' do
        expect(show_app user_application).to have_http_status(200)
      end

      xit 'should not show admin app' do
        expect(show_app admin_application).to have_http_status(302)
      end
    end

    context 'if admin' do
      before { sign_in_admin }

      it 'should show user app' do
        expect(show_app user_application).to have_http_status(200)
      end

      it 'should show admin app' do
        expect(show_app admin_application).to have_http_status(200)
      end
    end

    context 'if no user' do
      it 'should not show user app' do
        expect(show_app user_application).to have_http_status(302)
      end

      it 'should not show admin app' do
        expect(show_app admin_application).to have_http_status(302)
      end
    end
  end

  describe 'post #DESTROY' do
    def destroy_app(app)
      post :destroy, id: app.id
    end

    context 'if user' do
      before { sign_in_user }

      it 'should destroy user application' do
        expect { destroy_app user_application }.to change { Application.count }.by(-1)
      end

      xit 'should not destroy admin application' do
        expect { destroy_app admin_application }.to change { Application.count }.by(0)
      end
    end

    context 'if admin' do
      before { sign_in_admin }

      it 'should destroy user application' do
        expect { destroy_app user_application }.to change { Application.count }.by(-1)
      end

      it 'should destroy admin application' do
        expect { destroy_app admin_application }.to change { Application.count }.by(-1)
      end
    end

    context 'if no user' do
      it 'should not destroy user application' do
        expect { destroy_app user_application }.to change { Application.count }.by(0)
      end

      it 'should not destroy admin application' do
        expect { destroy_app admin_application }.to change { Application.count }.by(0)
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
      before { session[:user_id] = user.id }

      it 'should update user application' do
        check_update(user_application, true)
      end

      # 404???
      xit 'should not update admin application' do
        check_update(admin_application, false)
      end
    end

    context 'if admin' do
      before { session[:user_id] = admin.id }

      it 'should update user application' do
        check_update(user_application, true)
      end

      it 'should update admin application' do
        check_update(admin_application, true)
      end
    end

    context 'if no user' do
      # 302 here ?
      it 'should not update user application' do
        check_update(user_application, false)
      end

      # 302 here ?
      it 'should not update admin application' do
        check_update(admin_application, false)
      end
    end
  end
end
