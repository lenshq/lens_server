require 'rails_helper'

RSpec.feature 'Registration' do
  before(:each) { visit sign_up_path }

  scenario 'with valid form data will create new User' do
    fill_in 'registration_email', with: Faker::Internet.email
    fill_in 'registration_password', with: 'password123'
    fill_in 'registration_password_confirmation', with: 'password123'
    expect do
      click_button I18n.t('registrations.new.submit')
    end.to change(User, :count).by(1)
    expect(page).to have_content I18n.t 'flash.signed_up'
  end
end
