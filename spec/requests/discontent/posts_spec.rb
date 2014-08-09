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
        click_link 'to_work'
      end

      it ' can see all discontents in aspect' do
        expect have_content @discontent1.content
        expect have_content @discontent2.content
        expect have_selector '#add_record'
      end

      it ' add new discontent send', js: true do
        click_link 'add_record'
        fill_in 'discontent_post_content', with: 'dis content'
        fill_in 'discontent_post_whered', with: 'dis where'
        fill_in 'discontent_post_whend', with: 'dis when'
        # find("option[value='1']").click
        click_button 'send_post'
        expect have_content 'Перейти к списку'
        expect have_content 'Добавить еще одно'
      end
    end

    context 'show discontents'   do
      before do
        visit discontent_post_path(project, @discontent1)
      end

      it 'can see right form' do
        expect have_content @discontent1.content
        expect have_content @discontent1.whend
        expect have_content @discontent1.whered
        expect have_selector 'textarea#comment_text_area'
      end

      it ' can add  comments '  do
        fill_in 'comment_text_area', with: 'dis comment 1'
        click_button 'send_post'
        expect have_content 'dis comment 1'
      end
    end

    context ' validation links' do
      it ' validate journal' do
        visit journals_path(project)
        expect have_content 'dis comment 1'
        expect have_selector "a", @discontent1.content
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
  end

  context 'expert sign in' do
  end

end