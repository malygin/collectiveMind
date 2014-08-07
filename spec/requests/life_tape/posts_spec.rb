# encoding: utf-8
require 'spec_helper'
describe 'Life Tape ' do
  subject { page }

  before  do
    @project = FactoryGirl.create :core_project
    @aspect1 = FactoryGirl.create :aspect, project: @project, content: 'aspect 1'
    @aspect2 = FactoryGirl.create :aspect, project: @project, content: 'aspect 2'
  end

  context  'ordinary user sign in ' do
    before do
      @user = FactoryGirl.create :user
      sign_in @user
      #visit root_path
    end
    it ' view comments list in aspect' do
     # screenshot_and_open_image
     click_link 'go_to_project'
     click_link 'to_work'
     should have_content @aspect1.content
     should have_content @aspect2.content
     should have_selector 'textarea#comment_text_area'
    end
    it ' view comments list in aspect', js: true do
      fill_in 'comment_text_area', with: 'comment 1'
      click_button 'send_post'
      expect have_content 'comment 1'
    end
  end

  context 'moderator sign in' do
  end

  context 'expert sign in' do
  end

end