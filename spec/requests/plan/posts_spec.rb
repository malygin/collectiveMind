# encoding: utf-8
require 'spec_helper'

describe 'Plan ' do
  subject { page }

  let (:user) {create :user }
  let (:project) {create :core_project, status: 9 }

  before  do
    prepare_plans(project)
    sign_in user
  end

  context  'ordinary user sign in ' do
    context 'plan list' do
      before do
        visit plan_posts_path(project)
        click_link 'to_work'
        #save_and_open_page
      end
      it ' can see plan' do
        #save_and_open_page
        expect(page).to have_content @plan1.name
        expect(page).to have_selector '#add_record'
      end
      before do
        click_link 'add_record'
      end
      it ' add new plan', js: true do
        expect(page).to have_content 'Сохранить и приступить к добавлению этапов'
        fill_in 'name_plan', with: 'plan name'
        fill_in 'goals', with: 'plan goal'
        fill_in 'desc_plan', with: 'plan content'
        click_button 'send_plan_post'
        expect(page).to have_content 'Добавить этап в проект'
      end
      it_behaves_like 'validation links', :user, :project
      #it ' link to add stage', js: true do
      #  screenshot_and_open_image
      #  click_on 'btn_new_stage'
      #  expect have_content 'Добавление этапа в проект'
      #  fill_in 'name_stage', with: 'name stage'
      #  fill_in 'desc_stage', with: 'desc stage'
      #  click_button 'send_post'
      #  expect have_content 'name stage'
      #end
    end
    context 'show plan' do
      before do
        visit plan_post_path(project, @plan1)
      end

      it 'can see right form' do
        expect(page).to have_content @plan1.name
        expect(page).to have_content @plan1.goal
        expect(page).to have_content @plan1.content
        expect(page).to have_selector 'textarea#comment_text_area'
      end

      it ' can add comments '  do
        fill_in 'comment_text_area', with: 'plan comment 1'
        click_button 'send_post'
        expect(page).to have_content 'plan comment 1'
      end
      it_behaves_like 'validation links', :user, :project
    end
    context ' validation links' do
      it ' validate journal' do
        visit journals_path(project)
        expect(page).to have_content 'plan comment 1'
        expect(page).to have_selector "a", @plan1.name
      end
      it ' validate knowbase' do
        visit knowbase_posts_path(project)
        expect(page).to have_selector "a", 'вернуться к процедуре'
      end
      it ' validate help' do
        visit help_posts_path(project)
        expect(page).to have_selector "a", 'вернуться к процедуре'
      end
      it ' validate reiting' do
        visit users_path(project)
        expect(page).to have_content 'Рейтинг участников'
      end
      it ' validate profile' do
        visit user_path(project,user)
        expect(page).to have_content user.to_s
        expect(page).to have_content 'Достижения'
      end
      it_behaves_like 'validation links', :user, :project
    end
  end

  context 'moderator sign in' do
  end

  context 'expert sign in' do
  end

end