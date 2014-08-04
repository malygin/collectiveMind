include ApplicationHelper

def sign_in user
  visit new_user_session_path
  fill_in 'user_email', with: user.email
  fill_in 'user_password', with: 'pascal2003'
  click_button 'Signin'
end

def sign_out
  click_link 'sign_out'
end

