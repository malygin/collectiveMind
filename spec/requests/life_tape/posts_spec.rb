# encoding: utf-8
require 'spec_helper'
describe 'Life Tape ' do
  subject { page }
  # screenshot_and_open_image
  # save_and_open_page
  let (:user) {create :user }
  let (:user_data) {create :user }
  let (:prime_admin) {create :prime_admin }
  let (:moderator) {create :moderator }
  let (:project) {create :core_project, status: 1 }
  let (:closed_project) {create :core_project, status: 1 , type_access: 2, name: "closed project"}

  before  do
    prepare_life_tape(project,user_data)
  end

  context  'ordinary user sign in ' do
    before do
      sign_in user
      visit root_path
    end

    context 'success go to project ' do
      before do
        click_link "go_to_opened_project_#{project.id}"
      end
      it 'have content for user ' do
        expect(page).to have_content @aspect1.content
        expect(page).to have_content @aspect2.content
        expect(page).not_to  have_selector '#new_aspect'
        expect(page).to have_selector 'textarea#comment_text_area'
        expect(page).not_to have_link("plus_comment_#{@comment1.id}", :text => 'Выдать баллы', :href => plus_comment_life_tape_post_path(project,@comment1))
        validate_default_links_and_sidebar(project,user)
        validate_not_have_admin_links_for_user(project)
        validate_not_have_moderator_links_for_user(project)

        validation_visit_links_for_user(project,user)
        validation_visit_not_have_links_for_user(project,user)
      end
    end

    context 'life tape list ' do
      before do
        visit life_tape_posts_path(project)
      end

      it_behaves_like 'content with comments', false, 2

    end

    context 'vote life tape '  do
      before do
        project.update_attributes(:status => 2)
        visit life_tape_posts_path(project)
      end

      it 'have content ', js:true do
        expect(page).to have_content '1 этап: Сбор информации. Голосование'
        expect(page).to have_content 'Определение наиболее важных тем процедуры'
        expect(page).to have_content "Вы можете выбрать #{project.stage1_count} тем(ы), которые на Ваш взгляд являются наиболее важными"
        expect(page).to have_content "Осталось голосов: #{project.stage1_count}"
        expect(page).to have_content @aspect1.content
        expect(page).to have_content @aspect2.content
        click_link "vote_#{@aspect1.id}"
        expect(page).to have_content "Осталось голосов: #{project.stage1_count - 1}"
        click_link "vote_#{@aspect2.id}"
        expect(page).to have_content "Осталось голосов: 0"
        expect(page).to have_content 'Спасибо за участие в голосовании!'
        expect(page).to have_selector 'a', 'Перейти к рефлексии'
        expect(page).to have_selector 'a', 'Перейти к списку тем'
        click_link "Перейти к рефлексии"
        expect(page).to have_content "Рефлексия по этапу: Сбор информации"
      end
    end
  end

  context 'moderator sign in' do
    before do
      sign_in moderator
      visit root_path
    end

    context 'success go to project ' do
      before do
        click_link "go_to_opened_project_#{project.id}"
      end
      it 'have content for moderator ' do
        expect(page).to have_content @aspect1.content
        expect(page).to have_content @aspect2.content
        expect(page).to have_selector '#new_aspect'
        expect(page).to have_selector 'textarea#comment_text_area'

        validate_default_links_and_sidebar(project,moderator)
        validate_not_have_admin_links_for_moderator(project)
        validate_have_moderator_links(project)

        validation_visit_links_for_user(project,moderator)
        validation_visit_links_for_moderator(project)
        validation_visit_not_have_links_for_moderator(project,moderator)
      end
    end

    context 'life tape list ' do
      before do
        visit life_tape_posts_path(project)
      end

      it 'view aspects ' do
        expect(page).to have_content @aspect1.content
        expect(page).to have_content @aspect2.content
      end

      it_behaves_like 'content with comments', true, 2

    end
    context 'vote life tape '  do
      before do
        project.update_attributes(:status => 2)
        visit life_tape_posts_path(project)
      end

      it 'have content ', js:true do
        expect(page).to have_content '1 этап: Сбор информации. Голосование'
        expect(page).to have_content 'Определение наиболее важных тем процедуры'
        expect(page).to have_content "Вы можете выбрать #{project.stage1_count} тем(ы), которые на Ваш взгляд являются наиболее важными"
        expect(page).to have_content "Осталось голосов: #{project.stage1_count}"
        expect(page).to have_content @aspect1.content
        expect(page).to have_content @aspect2.content
        expect(page).to have_selector 'a', 'Перейти к рефлексии'
        expect(page).to have_link("set_vote_#{@aspect1.id}", :text => 'Убрать', :href => set_aspect_status_life_tape_post_path(project,@aspect1))
        click_link "set_vote_#{@aspect1.id}"
        expect(page).to have_link("set_vote_#{@aspect1.id}", :text => 'Вернуть', :href => set_aspect_status_life_tape_post_path(project,@aspect1))
        click_link "set_vote_#{@aspect1.id}"
        expect(page).to have_link("set_vote_#{@aspect1.id}", :text => 'Убрать', :href => set_aspect_status_life_tape_post_path(project,@aspect1))
        click_link "vote_#{@aspect1.id}"
        expect(page).to have_content "Осталось голосов: #{project.stage1_count - 1}"
        click_link "vote_#{@aspect2.id}"
        expect(page).to have_content "Осталось голосов: 0"
        expect(page).to have_content 'Спасибо за участие в голосовании!'
        expect(page).to have_selector 'a', 'Перейти к рефлексии'
        expect(page).to have_selector 'a', 'Перейти к списку тем'
        click_link "Перейти к рефлексии"
        expect(page).to have_content "Рефлексия по этапу: Сбор информации"
      end
    end

  end

  context 'expert sign in' do
  end

end