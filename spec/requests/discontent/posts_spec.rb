# encoding: utf-8
require 'spec_helper'

describe 'Discontents ' do
  subject { page }

  let (:user) {create :user }
  let (:project) {create :core_project, status: 3 }

  before  do
    prepare_discontents(project)
    sign_in user
  end

  context  'ordinary user sign in ' do
    context 'discontent list' do
      before do
        visit discontent_posts_path(project)
      end

      it ' can see all discontents in aspect' do
        expect(page).to have_content @discontent1.content
        expect(page).to have_content @discontent2.content
        expect(page).to have_selector '#add_record'
      end

      it ' add new discontent send', js: true do
        click_link 'add_record'
        fill_in 'discontent_post_content', with: 'dis content'
        fill_in 'discontent_post_whered', with: 'dis where'
        fill_in 'discontent_post_whend', with: 'dis when'
        select('aspect 1', :from => 'select_for_aspects')
        click_button 'send_post'
        expect(page).to have_content 'Перейти к списку'
        expect(page).to have_content 'Добавить еще одно'
      end
      it_behaves_like 'validation links', :user, :project
    end

    context 'show discontents'   do
      before do
        visit discontent_post_path(project, @discontent1)
      end

      it 'can see right form' do
        #save_and_open_page
        expect(page).to have_content @discontent1.content
        expect(page).to have_content @discontent1.whend
        expect(page).to have_content @discontent1.whered
        expect(page).to have_selector 'textarea#comment_text_area'
      end

      it ' can add  comments ', js: true  do
        fill_in 'comment_text_area', with: 'dis comment 1'
        click_button 'send_post'
        expect(page).to have_content 'dis comment 1'
      end
    end

  end

  context 'moderator sign in' do
  end

  context 'expert sign in' do
  end

end