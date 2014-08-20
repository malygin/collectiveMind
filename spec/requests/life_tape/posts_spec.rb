# encoding: utf-8
require 'spec_helper'
describe 'Life Tape ' do
  subject { page }
  # screenshot_and_open_image
  # save_and_open_page
  let (:user) {create :user }
  let (:admin) {create :admin }
  let (:project) {create :core_project, status: 1 }
  let (:closed_project) {create :core_project, status: 1 , type_access: 2, name: "closed project"}

  before  do
    prepare_life_tape(project)
  end

  context  'ordinary user sign in ' do
    before do
      sign_in user
      visit root_path
    end

    context 'root path' do
      before do
        click_link 'go_to_project'
      end
      it ' view root path redirect' do
        expect(page).to have_content @aspect1.content
        expect(page).to have_content @aspect2.content
        expect(page).not_to  have_selector '#new_aspect'
        expect(page).to have_selector 'textarea#comment_text_area'
      end
      it_behaves_like 'validation links', :user, :project
    end


    context ' life tape list' do
      before do
        visit life_tape_posts_path(project)
      end

      it ' view comments list in aspect', js: true do
       # screenshot_and_open_image
       expect(page).to have_content @aspect1.content
       expect(page).to have_content @aspect2.content
       expect(page).to have_selector 'textarea#comment_text_area'
      end

      it ' add new comment list in aspect', js: true do
        fill_in 'comment_text_area', with: 'comment 1'
        click_button 'send_post'
        expect(page).to have_content 'comment 1'
      end
    end
  end

  context 'moderator sign in' do
    before do
      sign_in admin
      visit root_path
    end

    context 'life tape comments' do
      before do
        visit life_tape_posts_path(project)
      end

      it ' view comments list in aspect for admin' do
        expect(page).to have_content @aspect1.content
        expect(page).to have_content @aspect2.content
        expect(page).to have_selector 'textarea#comment_text_area'
      end
    end

  end

  context 'expert sign in' do
  end

end