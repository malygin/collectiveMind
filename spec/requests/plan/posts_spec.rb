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
    before do
      visit plan_posts_path(project)
    end
    context 'plan list' do
      it ' can see plan' do
        #save_and_open_page
        expect(page).to have_content @plan1.name
        expect(page).to have_selector '#add_record'
      end
    end
    #context 'add_record' do
    #  before do
    #    click_link 'add_record'
    #  end
    #  it ' add new plan', js: true do
    #    #screenshot_and_open_image
    #    fill_in 'name_plan', with: 'plan name'
    #    fill_in 'goals', with: 'plan goal'
    #    fill_in 'desc_plan', with: 'plan content'
    #    click_button 'send_plan_post'
    #    expect(page).to have_content 'Добавить этап в проект'
    #  end
    #end
    context 'show plan' do
      before do
        visit plan_post_path(project, @plan1)
      end

      it 'can see right form' do
        #save_and_open_page
        expect(page).to have_content @plan1.name
        expect(page).to have_content @plan1.goal
        expect(page).to have_content @plan1.content
        expect(page).to have_selector 'textarea#comment_text_area'
      end

      it ' can add comments ' , js: true do
        #screenshot_and_open_image
        fill_in 'comment_text_area', with: 'plan comment 1'
        click_button 'send_post'
        expect(page).to have_content 'plan comment 1'
      end
    end
  end

  context 'moderator sign in' do
  end

  context 'expert sign in' do
  end

end