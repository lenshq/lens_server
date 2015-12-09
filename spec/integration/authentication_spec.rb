require 'rails_helper'
include SessionHelpers

RSpec.feature 'Authentication' do
  before(:each) { @user = create(:user) }

  scenario 'user can sign in with valid Email and Password' do
    sign_in(@user.email, @user.password)
    expect(page).to have_content I18n.t 'flash.signed_in'
  end

  scenario 'user cannot sign in with wrong email' do
    sign_in('wrong@test.com', @user.password)
    expect(page).to have_content I18n.t 'flash.authentication_error'
  end

  scenario 'user cannot sign in with wrong password' do
    sign_in(@user.email, 'wrong_pass')
    expect(page).to have_content I18n.t 'flash.authentication_error'
  end

  scenario 'user can sign out' do
    sign_in(@user.email, @user.password)
    click_link 'Sign out'
    expect(current_path).to eq root_path
  end
end
