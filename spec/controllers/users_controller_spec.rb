require 'rails_helper'
include AuthHelper

RSpec.describe UsersController do
  render_views

  let(:user) { create :user }
  let(:another_user) { create :user }

  describe 'get #NEW' do
    subject { get :new }

    context 'if user' do
      before { sign_in user }

      it { is_expected.to have_http_status(302) }
      it { is_expected.to redirect_to(root_path) }
    end

    context 'if no user' do
      it { is_expected.to have_http_status(200) }
    end
  end

  describe 'post #CREATE' do
    let(:user_attrs) { { user: attributes_for(:user) } }
    subject { post :create, user_attrs }

    context 'if user' do
      before { sign_in user }

      it { expect { subject }.to change { User.count }.by(0) }
      it { is_expected.to have_http_status(302) }
      it { is_expected.to redirect_to(root_path) }
    end

    context 'if no user' do
      it { expect { subject }.to change { User.count }.by(1) }
      it { is_expected.to have_http_status(302) }
      it { is_expected.to redirect_to(applications_path) }
    end
  end

  describe 'post #DESTROY' do
    def destroy(id)
      post :destroy, id: id
    end

    context 'if user' do
      before { sign_in user }

      it 'should destroy user' do
        expect { destroy(user.id) }.to change { User.count }.by(-1)
      end

      context 'if trying to destroy another user' do
        it 'has 401 status' do
          expect(destroy(another_user.id)).to have_http_status(401)
        end
      end
    end

    context 'if no user' do
      it 'should not destroy user' do
        expect(destroy(user.id)).to have_http_status(401)
      end
    end
  end

  describe 'get #EDIT' do
    def edit(id)
      get :edit, id: id
    end

    context 'if user' do
      before { sign_in user }

      it { expect(edit(user.id)).to have_http_status(200) }

      context 'if trying to edit another user' do
        it { expect(edit(another_user.id)).to have_http_status(401) }
      end
    end

    context 'if no user' do
      it { expect(edit(user.id)).to have_http_status(401) }
    end
  end

  describe 'post #UPDATE' do
    let(:valid_attrs) { { email: 'new_user_email@example.com' } }
    let(:invalid_attrs) { { email: '' } }

    context 'if user' do
      before { sign_in user }

      it 'updates user with valid attributes' do
        put :update, id: user.id, user: valid_attrs
        expect(User.find(user.id).email).to eq(valid_attrs[:email])
        # FIXME: weid-broken-thing
        # expect { put :update, id: user.id, user: valid_attrs }.
        #   to change(user.reload, :email).from(user.email).to(valid_attrs[:email])
      end

      it 'doesn\'t update user with invalid attributes' do
        expect { put :update, id: user.id, user: invalid_attrs }.not_to change(user, :email)
      end

      it 'should not update another user' do
        expect(put(:update, id: another_user.id, user: valid_attrs)).
          to have_http_status(401)
      end
    end

    context 'if no user' do
      it 'should not update user application' do
        expect(put(:update, id: user.id, user: valid_attrs)).
          to have_http_status(401)
      end
    end
  end
end
