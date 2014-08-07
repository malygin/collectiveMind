# encoding: utf-8
require 'spec_helper'

describe 'Plan ' do
  subject { page }

  before  do
    @project = FactoryGirl.create :core_project, status: 9
    @aspect1 = FactoryGirl.create :aspect, project: @project, content: 'aspect 1'
    @aspect2 = FactoryGirl.create :aspect, project: @project, content: 'aspect 2'
    @discontent1 = FactoryGirl.create :discontent, project: @project, status:4, content: 'discontent 1', whend: 'when 1', whered: 'where 1'
    @discontent2 = FactoryGirl.create :discontent, project: @project, status:4, content: 'discontent 2', whend: 'when 2', whered: 'where 2'
    @disasp1 = FactoryGirl.create :discontent_post_aspect, post_id: @discontent1, aspect_id: @aspect1
    @disasp1 = FactoryGirl.create :discontent_post_aspect, post_id: @discontent2, aspect_id: @aspect1

    @concept1 = FactoryGirl.create :concept, project: @project
    @concept2 = FactoryGirl.create :concept, project: @project
    @concept_aspect1 = FactoryGirl.create :concept_aspect, project: @project, discontent_aspect_id: @discontent1, concept_post_id: @concept1,positive:'positive 1', negative: 'negative 1', title: 'title 1', control:'control 1', content:'content 1',reality:'reality 1',problems:'problems 1',name:'name 1'
    @concept_aspect2 = FactoryGirl.create :concept_aspect, project: @project, discontent_aspect_id: @discontent1, concept_post_id: @concept2,positive:'positive 2', negative: 'negative 2', title: 'title 2', control:'control 2', content:'content 2',reality:'reality 2',problems:'problems 2',name:'name 2'
    @condis1 = FactoryGirl.create :concept_post_discontent, post_id: @concept1, discontent_post_id: @discontent1
    @condis2 = FactoryGirl.create :discontent_post_aspect, post_id: @concept2, discontent_post_id: @discontent1

    @plan1 = FactoryGirl.create :plan, project: @project, name: 'name 1', goal: 'goal 1', content: 'content 1'
    @plan_stage1 = FactoryGirl.create :plan_aspect, post_id: @plan1, name: 'name 1', desc: 'desc 1'
    @plan_aspect1 = FactoryGirl.create :plan_aspect, plan_post_id: @plan1, post_stage_id: @plan_stage1
    @plan_action1 = FactoryGirl.create :plan_action, plan_post_aspect_id: @plan_aspect1, name: 'name 1', desc: 'desc 1'
  end

  context  'ordinary user sign in ' do
    before do
      @user = FactoryGirl.create :user
      sign_in @user
      visit plan_posts_path(@project)
    end
    it ' view plan list' do
      should have_content @plan1.name
      should have_selector '#add_record'
    end
    it ' view plan show' do
      visit plan_post_path(@project, @plan1)
      should have_content @plan1.name
      should have_content @plan1.goal
      should have_content @plan1.content
    end
    it ' add new plan' do
      visit plan_posts_path(@project)
      click_link 'add_record'
      should have_content 'Форма добавления несовершенства'
      it ' add new discontent send', js: true do
        fill_in 'name_plan', with: 'plan name'
        fill_in 'name_goal', with: 'plan goal'
        fill_in 'name_content', with: 'plan content'
        click_button 'send_plan_post'
        expect have_content 'Добавить этап в проект'
        it ' link to add stage', js: true do
          click_link 'btn_new_stage'
          expect have_content 'Добавление этапа в проект'
          fill_in 'name_stage', with: 'name stage'
          fill_in 'desc_stage', with: 'desc stage'
          click_button 'send_post'
          expect have_content 'name stage'
        end
      end
    end
  end

  context 'moderator sign in' do
  end

  context 'expert sign in' do
  end

end