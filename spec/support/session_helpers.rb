module SessionHelpers
  def sign_in(email, password)
    visit sign_in_path
    fill_in 'session_email', with: email
    fill_in 'session_password', with: password
    click_button I18n.t('sessions.new.submit')
  end
end
