# encoding: utf-8
require 'spec_helper'
describe 'Life Tape ' do
  subject { page }
  # screenshot_and_open_image
  let (:user) {create :user }
  let (:admin) {create :admin }
  let (:project) {create :core_project, status: 1 }

  before  do
    prepare_life_tape(project)
    sign_in user
  end

  context  'ordinary user sign in ' do
    context 'root path' do
      before do
        visit root_path
        click_link 'go_to_project'
        click_link 'to_work'
      end
      it ' view root path redirect' do
        expect have_content @aspect1.content
        expect have_content @aspect2.content
        expect have_selector '#new_aspect'
        expect have_selector 'textarea#comment_text_area'
      end
    end

    context ' life tape list' do
      before do
        visit life_tape_posts_path(project)
        click_link 'to_work'
        #save_and_open_page
      end

      it ' view comments list in aspect' do
       expect have_content @aspect1.content
       expect have_content @aspect2.content
       expect have_selector 'textarea#comment_text_area'
      end

      it ' add new comment list in aspect', js: true do
        #screenshot_and_open_image
        fill_in 'comment_text_area', with: 'comment 1'
        click_button 'send_post'
        expect have_content 'comment 1'
      end
    end
    context ' validation links' do
      it ' validate journal' do
        visit journals_path(project)
        expect have_content 'comment 1'
        expect have_selector "a", @aspect1.content
      end
      it ' validate knowbase' do
        visit knowbase_posts_path(project)
        expect have_selector "a", 'вернуться к процедуре'
      end
      it ' validate help' do
        visit help_posts_path(project)
        expect have_selector "a", 'вернуться к процедуре'
      end
      it ' validate reiting' do
        visit users_path(project)
        expect have_content 'Рейтинг участников'
      end
      it ' validate profile' do
        visit user_path(project,user)
        expect have_content user.to_s
        expect have_content 'Достижения'
      end
    end
  end

  context 'moderator sign in' do
    before do
      sign_out
      sign_in admin
      visit life_tape_posts_path(project)
      click_link 'to_work'
    end

    it ' view comments list in aspect for admin' do
      expect have_content @aspect1.content
      expect have_content @aspect2.content
      expect have_selector 'textarea#comment_text_area'
    end

    #it ' add new aspect for admin', js: true do
    #  click_link 'new_aspect'
    #  fill_in 'aspect_text_field_content', with: 'new aspect for test'
    #  #expect{ click_button 'send_post_aspect'}.to have_content 'new aspect for test'
    #end
    #it ' add new aspect for admin' do
    #  click_button 'send_post_aspect'
    #  expect have_content 'new aspect for test'
    #end
  end

  context 'expert sign in' do
  end

end