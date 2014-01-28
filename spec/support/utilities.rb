include ApplicationHelper



def sign_in(user)
  visit '/users/sign_in'
  fill_in "user_email",    with: user.email
  fill_in "user_password", with: user.password
  click_button "Signin"
  # Sign in when not using Capybara.
  cookies[:remember_token] = [user.id, user.salt]
end

def sign_out
  visit signout_path
  
end