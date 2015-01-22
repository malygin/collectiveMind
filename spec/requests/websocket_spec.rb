require 'spec_helper'

describe 'Users ' do
  subject { page }

  context 'ordinary user sign in ', js: true do
    it 'login' do
      visit 'http://0.0.0.0:3000'
      click_link 'sign_in'
      fill_in 'user_email', with: 'anmalygin@gmail.com'
      fill_in 'user_password', with: 'pascal2003'
      click_button 'Signin'
      expect(current_path).to eq root_path
      screenshot_and_save_page
    end
  end
end
