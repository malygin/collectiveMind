# encoding: utf-8
require 'spec_helper'

describe 'Concept ' do
  subject { page }

  before  do
    @project = FactoryGirl.create :core_project, status: 7
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

  end

  context  'ordinary user sign in ' do
    before do
      @user = FactoryGirl.create :user
      sign_in @user
      visit concept_posts_path(@project)
    end
    it ' view concept list in aspect' do
      should have_content @discontent1.content
      should have_content @discontent2.content
      should have_content @concept_aspect1.title
      should have_content @concept_aspect2.title
    end
    it ' view concept show' do
      visit concept_post_path(@project, @concept1)
      should have_content @concept1.title
      should have_content @concept1.positive
      should have_content @concept1.negative
      should have_content @concept1.content
      should have_content @concept1.control
      should have_content @concept1.reality
      should have_content @concept1.problems
      should have_selector 'textarea#comment_text_area'
      it ' view comments concept in show', js: true do
        fill_in 'comment_text_area', with: 'con comment 1'
        click_button 'send_post'
        expect have_content 'con comment 1'
      end
    end
    it ' add new concept' do
      visit concept_posts_path(@project)
      fill_in 'comment_text_area', with: 'comment 1'
      click_link "new_discontent_#{@discontent1.id}"
      should have_content 'Краткое название вашего нововведения'
      fill_in "pa_#{@discontent1.id}_title", with: 'con title'
      fill_in "pa_#{@discontent1.id}_name", with: 'con name'
      fill_in "pa_#{@discontent1.id}_content", with: 'con content'
      fill_in "pa_#{@discontent1.id}_control", with: 'con control'
      fill_in "pa_#{@discontent1.id}_positive", with: 'con positive'
      fill_in "pa_#{@discontent1.id}_negative", with: 'con negative'
      fill_in "pa_#{@discontent1.id}_reality", with: 'con reality'
      fill_in "pa_#{@discontent1.id}_problems", with: 'con problems'
      click_button 'send_post'
      should have_content 'con title'
    end
  end

  context 'moderator sign in' do
  end

  context 'expert sign in' do
  end

end