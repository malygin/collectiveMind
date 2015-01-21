require 'spec_helper'

describe 'Plan ' do
  subject { page }
  # screenshot_and_open_image
  # save_and_open_page
  let (:user) { create :user }
  let (:project) { create :core_project, status: 9 }
  let (:prime_admin) { create :prime_admin }
  let (:moderator) { create :moderator }

  before do
    @plan1 = create :plan, project: project, user: user
    @plan_stage1 = create :plan_stage, post_id: @plan1.id
    @plan_aspect1 = create :plan_aspect, plan_post_id: @plan1.id, post_stage_id: @plan_stage1.id
    @plan_action1 = create :plan_action, plan_post_aspect_id: @plan_aspect1.id
  end

  context 'ordinary user sign in ' do
    before do
      sign_in user
      visit plan_posts_path(project)
    end

    context 'plan list' do
      it ' can see plan' do
        #save_and_open_page
        expect(page).to have_content @plan1.name
        expect(page).to have_selector '#add_record'
      end
    end

    context 'add_record' do
      before do
        click_link 'add_record'
      end

      it ' add new plan', js: true do
        fill_in 'name_plan', with: 'plan name'
        fill_in 'goals', with: 'plan goal'
        fill_in 'desc_plan', with: 'plan content'
        click_button 'send_plan_post'
        expect(page).to have_content 'Добавить этап в проект'
      end

      it ' add new stage', js: true do
        fill_in 'name_plan', with: 'plan name'
        fill_in 'goals', with: 'plan goal'
        fill_in 'desc_plan', with: 'plan content'
        click_button 'send_plan_post'
        expect(page).to have_content 'Добавить этап в проект'
        find("#btn_new_stage").click
        expect(page).to have_content 'Добавление этапа в проект'
        fill_in 'name_stage', with: 'name_stage'
        fill_in 'desc_stage', with: 'desc_stage'
        click_button 'send_post'
        expect(page).to have_content 'name_stage'
      end
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

      it ' can add comments ', js: true do
        fill_in 'comment_text_area', with: 'plan comment 1'
        click_button 'send_comment'
        expect(page).to have_content 'plan comment 1'
      end

      it 'can see second tab', js: true do
        find("li#second a").click
        expect(page).to have_content @plan_stage1.name
        expect(page).to have_content @plan_stage1.desc
        expect(page).to have_content @plan_aspect1.title
        expect(page).to have_content @plan_aspect1.name
        expect(page).to have_content @plan_action1.name
        expect(page).to have_content @plan_action1.desc
      end

      it 'can see third tab', js: true do
        find("li#third a").click
        expect(page).to have_content @plan_aspect1.title
        find("#li_concept_#{@plan_aspect1.id} a").click
        expect(page).to have_content @plan_aspect1.name
        expect(page).to have_content @plan_aspect1.content
        expect(page).to have_content @plan_aspect1.positive
        expect(page).to have_content @plan_aspect1.negative
        expect(page).to have_content @plan_aspect1.control
        expect(page).to have_content @plan_aspect1.obstacles
        expect(page).to have_content @plan_aspect1.reality
        expect(page).to have_content @plan_aspect1.problems
      end
    end

    context 'edit plan' do
      before do
        visit edit_plan_post_path(project, @plan1)
      end

      it 'can see right form' do
        expect(page).to have_content @plan1.name
        expect(page).to have_content @plan1.goal
        expect(page).to have_content @plan1.content
      end

      it 'can see edit stage modal', js: true do
        find("#edit_post_stage_#{@plan_stage1.id}").click
        expect(page).to have_content 'Добавление этапа в проект'
        fill_in 'name_stage', with: 'new name_stage'
        click_button 'send_post'
        expect(page).to have_content 'new name_stage'
      end

      it 'can see edit action modal', js: true do
        find("li#second a").click
        expect(page).to have_content "Этап 1. #{@plan_stage1.name}"
        find("#edit_post_action_#{@plan_action1.id}").click
        expect(page).to have_content 'Добавление мероприятия к нововведению:'
        fill_in 'name_stage', with: 'new name stage'
        click_button 'send_post'
        expect(page).to have_content 'new name stage'
      end

      it 'can see edit link concept add modal', js: true do
        find("li#second a").click
        expect(page).to have_content 'Добавить нововведение'
        expect(page).to have_content 'Запланировать мероприятие'
        click_link 'Добавить нововведение'
        expect(page).to have_content 'Добавление нововведений'
        expect(page).to have_content 'Добавить пустое нововведение'
      end

      it 'can see edit link action add modal', js: true do
        find("li#second a").click
        expect(page).to have_content 'Добавить нововведение'
        expect(page).to have_content 'Запланировать мероприятие'
        click_link 'Запланировать мероприятие'
        expect(page).to have_content 'Добавление мероприятия к нововведению:'
      end

      it 'can see edit link action add modal', js: true do
        find("li#third a").click
        expect(page).to have_content "Этап 1. #{@plan_stage1.name}"
        find("#li_concept_#{@plan_aspect1.id} a").click
        expect(page).to have_content @plan_aspect1.name
        expect(page).to have_content @plan_aspect1.content
        expect(page).to have_content @plan_aspect1.positive
        expect(page).to have_content @plan_aspect1.negative
        expect(page).to have_content @plan_aspect1.control
        expect(page).to have_content @plan_aspect1.obstacles
        expect(page).to have_content @plan_aspect1.reality
        expect(page).to have_content @plan_aspect1.problems
      end
    end
  end

  context 'moderator sign in' do
    before do
      sign_in moderator
      visit plan_posts_path(project)
    end

    context 'plan list' do
      it ' can see plan' do
        #save_and_open_page
        expect(page).to have_content @plan1.name
        expect(page).to have_selector '#add_record'
      end
    end

    context 'add_record' do
      before do
        click_link 'add_record'
      end

      it ' add new plan', js: true do
        fill_in 'name_plan', with: 'plan name'
        fill_in 'goals', with: 'plan goal'
        fill_in 'desc_plan', with: 'plan content'
        click_button 'send_plan_post'
        expect(page).to have_content 'Добавить этап в проект'
      end

      it ' add new stage', js: true do
        fill_in 'name_plan', with: 'plan name'
        fill_in 'goals', with: 'plan goal'
        fill_in 'desc_plan', with: 'plan content'
        click_button 'send_plan_post'
        expect(page).to have_content 'Добавить этап в проект'
        find("#btn_new_stage").click
        expect(page).to have_content 'Добавление этапа в проект'
        fill_in 'name_stage', with: 'name_stage'
        fill_in 'desc_stage', with: 'desc_stage'
        click_button 'send_post'
        expect(page).to have_content 'name_stage'
      end
    end

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

      it ' can add comments ', js: true do
        # screenshot_and_open_image
        fill_in 'comment_text_area', with: 'plan comment 1'
        find('input.send-comment').click
        expect(page).to have_content 'plan comment 1'
      end

      it 'can see second tab', js: true do
        find("li#second a").click
        expect(page).to have_content @plan_stage1.name
        expect(page).to have_content @plan_stage1.desc
        expect(page).to have_content @plan_aspect1.title
        expect(page).to have_content @plan_aspect1.name
        expect(page).to have_content @plan_action1.name
        expect(page).to have_content @plan_action1.desc
      end

      it 'can see third tab', js: true do
        find("li#third a").click
        expect(page).to have_content @plan_aspect1.title
        find("#li_concept_#{@plan_aspect1.id} a").click
        expect(page).to have_content @plan_aspect1.name
        expect(page).to have_content @plan_aspect1.content
        expect(page).to have_content @plan_aspect1.positive
        expect(page).to have_content @plan_aspect1.negative
        expect(page).to have_content @plan_aspect1.control
        expect(page).to have_content @plan_aspect1.obstacles
        expect(page).to have_content @plan_aspect1.reality
        expect(page).to have_content @plan_aspect1.problems
      end
    end

    context 'edit plan' do
      before do
        visit edit_plan_post_path(project, @plan1)
      end

      it 'can see right form' do
        expect(page).to have_content @plan1.name
        expect(page).to have_content @plan1.goal
        expect(page).to have_content @plan1.content
      end

      it 'can see edit stage modal', js: true do
        find("#edit_post_stage_#{@plan_stage1.id}").click
        expect(page).to have_content 'Добавление этапа в проект'
        fill_in 'name_stage', with: 'new name_stage'
        click_button 'send_post'
        expect(page).to have_content 'new name_stage'
      end

      # it 'can see edit concept modal', js: true do
      #   find("li#second a").click
      #   expect(page).to have_content 'Этап 1. stage name 1'
      #   find("#edit_post_concept_#{@plan_aspect1.id}").click
      #   expect(page).to have_content 'Редактирование нововведения в рамках этапа:'
      #   fill_in 'plan_post_aspect_title', with: 'new title concept'
      #   click_button 'send_post'
      #   sleep(5)
      #   expect(page).to have_content 'new title concept'
      # end

      it 'can see edit action modal', js: true do
        find("li#second a").click
        expect(page).to have_content "Этап 1. #{@plan_stage1.name}"
        find("#edit_post_action_#{@plan_action1.id}").click
        expect(page).to have_content 'Добавление мероприятия к нововведению:'
        fill_in 'name_stage', with: 'new name stage'
        click_button 'send_post'
        expect(page).to have_content 'new name stage'
      end

      it 'can see edit link concept add modal', js: true do
        find("li#second a").click
        expect(page).to have_content 'Добавить нововведение'
        expect(page).to have_content 'Запланировать мероприятие'
        click_link 'Добавить нововведение'
        expect(page).to have_content 'Добавление нововведений'
        expect(page).to have_content 'Добавить пустое нововведение'
      end

      it 'can see edit link action add modal', js: true do
        find("li#second a").click
        expect(page).to have_content 'Добавить нововведение'
        expect(page).to have_content 'Запланировать мероприятие'
        click_link 'Запланировать мероприятие'
        expect(page).to have_content 'Добавление мероприятия к нововведению:'
      end

      it 'can see second tab', js: true do
        find("li#second a").click
        expect(page).to have_content @plan_stage1.name
        expect(page).to have_content @plan_stage1.desc
        expect(page).to have_content @plan_aspect1.title
        expect(page).to have_content @plan_aspect1.name
        expect(page).to have_content @plan_action1.name
        expect(page).to have_content @plan_action1.desc
      end

      it 'can see third tab', js: true do
        find("li#third a").click
        expect(page).to have_content @plan_aspect1.title
        find("#li_concept_#{@plan_aspect1.id} a").click
        expect(page).to have_content @plan_aspect1.name
        expect(page).to have_content @plan_aspect1.content
        expect(page).to have_content @plan_aspect1.positive
        expect(page).to have_content @plan_aspect1.negative
        expect(page).to have_content @plan_aspect1.control
        expect(page).to have_content @plan_aspect1.obstacles
        expect(page).to have_content @plan_aspect1.reality
        expect(page).to have_content @plan_aspect1.problems
      end
    end
  end
end
