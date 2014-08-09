# encoding: utf-8
require 'spec_helper'

describe 'Concept ' do
  subject { page }

  let (:user) {create :user }
  let (:project) {create :core_project, status: 7 }

  before  do
    prepare_concepts(project)
    sign_in user
  end

  context  'ordinary user sign in ' do
    context 'concept list' do
      before do
        visit concept_posts_path(project)
        #save_and_open_page
        click_link 'to_work'
      end

      it ' can see all concepts in aspect' do
        expect have_content @discontent1.content
        expect have_content @discontent2.content
        expect have_content @concept_aspect1.title
        expect have_content @concept_aspect2.title
        expect have_selector "#new_concept_#{@discontent1.id}"
        expect have_selector "#new_concept_#{@discontent2.id}"
      end

      it ' add new concept' do
        #save_and_open_page
        click_link "new_concept_#{@discontent1.id}"
        expect have_content 'Краткое название вашего нововведения'
        fill_in "pa_#{@discontent1.id}_title", with: 'con title'
        fill_in "pa_#{@discontent1.id}_name", with: 'con name'
        fill_in "pa_#{@discontent1.id}_content", with: 'con content'
        fill_in "pa_#{@discontent1.id}_positive", with: 'con positive'
        fill_in "pa_#{@discontent1.id}_negative", with: 'con negative'
        fill_in "pa_#{@discontent1.id}_reality", with: 'con reality'
        fill_in "pa_#{@discontent1.id}_problems", with: 'con problems'
        click_button 'send_post_concept'
        expect have_content 'con title'
      end
    end

    context 'show concept'   do
      before do
        visit concept_post_path(project, @concept1)
      end

      it 'can see right form' do
        expect have_content @concept_aspect1.title
        expect have_content @concept_aspect1.name
        expect have_content @concept_aspect1.positive
        expect have_content @concept_aspect1.negative
        expect have_content @concept_aspect1.content
        expect have_content @concept_aspect1.control
        expect have_content @concept_aspect1.reality
        expect have_content @concept_aspect1.problems
        expect have_selector 'textarea#comment_text_area'
      end

      it ' can add comments ', js: true do
        #screenshot_and_open_image
        fill_in 'comment_text_area', with: 'con comment 1'
        click_button 'send_post'
        expect have_content 'con comment 1'
      end
    end
    context ' validation links' do
      it ' validate journal' do
        visit journals_path(project)
        expect have_content 'con comment 1'
        expect have_selector "a", @concept_aspect1.title
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