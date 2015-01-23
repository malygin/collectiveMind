require 'spec_helper'

describe 'Users ' do
  subject { page }

  context 'ordinary user sign in ', js: true do
    before do
      visit 'http://0.0.0.0:3000'
      click_link 'sign_in'
      fill_in 'user_email', with: 'test@gmail.com'
      fill_in 'user_password', with: 'pascal2003'
      click_button 'Signin'
    end

    it 'go to project' do
      find("a[id^='go_to_opened_project_']").click
      #открываем чат
      find('span.ui-icon-minusthick').click
      sleep 15
      find('textarea.ui-chatbox-input-box').set "Test message\n"
      sleep 15
      screenshot_and_save_page
    end
  end
end
