include ApplicationHelper

def sign_in user
  #user = User.find_by_email(user.email)
  #puts user.email
  #puts user.password
  #puts user.valid_password?('pascal2003')
  visit new_user_session_path
  fill_in 'user_email', with: user.email
  fill_in 'user_password', with: 'pascal2003'

  click_button 'Signin'
end

def sign_out
  click_link 'sign_out'
end

