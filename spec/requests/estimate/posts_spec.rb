# encoding: utf-8
require 'spec_helper'

describe 'Discontents ' do
  subject { page }

  before  do
    @project = FactoryGirl.create :core_project, status: 2
    @aspect1 = FactoryGirl.create :aspect, project: @project, content: 'aspect 1'
    @aspect2 = FactoryGirl.create :aspect, project: @project, content: 'aspect 2'
    @discontent1 = FactoryGirl.create :discontent, project: @project, content: 'discontent 1', whend: 'when 1', whered: 'where 1'
    @discontent2 = FactoryGirl.create :discontent, project: @project, content: 'discontent 2', whend: 'when 2', whered: 'where 2'
    @disasp1 = FactoryGirl.create :discontent_post_aspect, post_id: @discontent1, aspect_id: @aspect1
    @disasp1 = FactoryGirl.create :discontent_post_aspect, post_id: @discontent2, aspect_id: @aspect1
  end

  context  'ordinary user sign in ' do
    before do
      @user = FactoryGirl.create :user
      sign_in @user
      visit discontent_posts_path(@project)
    end
    it ' view discontents list in aspect' do
      should have_content @discontent1.content
      should have_content @discontent2.content
      should have_selector '#add_record'
    end
    it ' view discontent show' do
      visit discontent_post_path(@project, @discontent1)
      should have_content @discontent1.content
      should have_content @discontent1.whend
      should have_content @discontent1.whered
      should have_selector 'textarea#comment_text_area'
      it ' view comments discontent in show', js: true do
        fill_in 'comment_text_area', with: 'dis comment 1'
        click_button 'send_post'
        expect have_content 'dis comment 1'
      end
    end
    it ' add new discontent' do
      visit discontent_posts_path(@project)
      fill_in 'comment_text_area', with: 'comment 1'
      click_link 'add_record'
      should have_content 'Форма добавления несовершенства'
      it ' add new discontent send', js: true do
        fill_in 'discontent_post_content', with: 'dis content'
        fill_in 'discontent_post_whered', with: 'dis where'
        fill_in 'discontent_post_whend', with: 'dis when'
        find("option[value='1']").click
        click_button 'send_post'
        expect have_content 'Перейти к списку'
        expect have_content 'Добавить еще одно'
        it ' link to list' do
          click_link 'to_dislist'
          should have_content 'dis content'
          should have_content 'dis where'
          should have_content 'dis when'
        end
      end
    end
  end

  context 'moderator sign in' do
  end

  context 'expert sign in' do
  end

end