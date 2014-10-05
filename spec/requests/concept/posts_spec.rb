# encoding: utf-8
require 'spec_helper'

describe 'Concept ' do
  subject { page }

  # screenshot_and_open_image
  # save_and_open_page
  let (:user) {create :user }
  let (:prime_admin) {create :prime_admin }
  let (:moderator) {create :moderator }
  let (:project) {create :core_project, status: 7 }

  before  do
    prepare_concepts(project,user)
  end

  context  'ordinary user sign in ' do
    before do
      sign_in user
      visit root_path
    end
    context 'concept list' do
      before do
        visit concept_posts_path(project)
      end

      it ' can see all concepts in aspect' do
        expect(page).to have_content 'Нововведения'
        expect(page).to have_content 'Неоформленные идеи'
        expect(page).to have_content @discontent1.content
        expect(page).to have_content @discontent2.content
        expect(page).to have_content @concept_aspect1.title
        expect(page).to have_content @concept_aspect2.title
        expect(page).to have_selector "#new_concept_#{@discontent1.id}"
        expect(page).to have_selector "#new_concept_#{@discontent2.id}"
      end

      it ' add new concept', js: true do
        click_link "new_concept_#{@discontent1.id}"
        expect(page).to have_content 'Краткое название вашего нововведения'
        expect(page).to have_content @discontent1.content
        expect(page).to have_selector '#main_positive_r_1 input.autocomplete'
        expect(page).to have_selector '#main_positive_s_1 input.autocomplete'
        expect(page).to have_selector '#main_negative_r_1 input.autocomplete'
        expect(page).to have_selector '#main_negative_s_1 input.autocomplete'
        expect(page).to have_selector '#main_control_r_1 input.autocomplete'
        expect(page).to have_selector '#main_control_s_1 input.autocomplete'

        fill_in "pa_title", with: 'con title'
        fill_in "pa_name", with: 'con name'
        fill_in "pa_content", with: 'con content'
        fill_in "pa_positive", with: 'con positive'
        fill_in "pa_negative", with: 'con negative'
        fill_in "pa_control", with: 'con control'
        fill_in "pa_obstacles", with: 'con obstacles'
        fill_in "pa_reality", with: 'con reality'
        fill_in "pa_problems", with: 'con problems'

        find(:css, "#main_positive_r_1 input.autocomplete[name='resor_positive_r[1][]']").set('positive_r_1')
        find(:css, "#main_positive_s_1 input.autocomplete[name='resor_positive_s[1][]']").set('positive_s_1')
        find(:css, "#main_negative_r_1 input.autocomplete[name='resor_negative_r[1][]']").set('negative_r_1')
        find(:css, "#main_negative_s_1 input.autocomplete[name='resor_negative_s[1][]']").set('negative_s_1')
        find(:css, "#main_control_r_1 input.autocomplete[name='resor_control_r[1][]']").set('control_r_1')
        find(:css, "#main_control_s_1 input.autocomplete[name='resor_control_s[1][]']").set('control_s_1')

        click_button 'send_post_concept'
        expect(page).to have_content 'Ваше нововведение успешно добавлено! Вы можете добавить еще одно или перейти к просмотру списка нововведений.'
        expect(page).to have_content 'Перейти к списку'
        expect(page).to have_content 'Добавить еще одно'
        click_link 'Перейти к списку'
        expect(page).to have_content 'con title'
        click_link 'con title'
        expect(page).to have_content 'con name'
        expect(page).to have_content 'con content'
        expect(page).to have_content 'con positive'
        expect(page).to have_content 'con negative'
        expect(page).to have_content 'con control'
        expect(page).to have_content 'con obstacles'
        expect(page).to have_content 'con reality'
        expect(page).to have_content 'con problems'
        expect(page).to have_content 'positive_r_1'
        expect(page).to have_content 'positive_s_1'
        expect(page).to have_content 'negative_r_1'
        expect(page).to have_content 'negative_s_1'
        expect(page).to have_content 'control_r_1'
        expect(page).to have_content 'control_s_1'
      end

      it ' can click button to resource', js: true do
        click_link "new_concept_#{@discontent1.id}"
        expect(page).to have_content 'Краткое название вашего нововведения'
        expect(page).to have_content @discontent1.content
        expect(page).to have_content @discontent1.whered
        expect(page).to have_content @discontent1.whend
        expect(page).to have_selector '#main_positive_r_1 input.autocomplete'
        expect(page).to have_selector '#main_positive_s_1 input.autocomplete'
        expect(page).to have_selector '#main_negative_r_1 input.autocomplete'
        expect(page).to have_selector '#main_negative_s_1 input.autocomplete'
        expect(page).to have_selector '#main_control_r_1 input.autocomplete'
        expect(page).to have_selector '#main_control_s_1 input.autocomplete'

        fill_in "pa_title", with: 'con title'
        fill_in "pa_name", with: 'con name'
        fill_in "pa_content", with: 'con content'
        fill_in "pa_positive", with: 'con positive'
        fill_in "pa_negative", with: 'con negative'
        fill_in "pa_control", with: 'con control'
        fill_in "pa_obstacles", with: 'con obstacles'
        fill_in "pa_reality", with: 'con reality'
        fill_in "pa_problems", with: 'con problems'

        find(:css, "#main_positive_r_1 input.autocomplete[name='resor_positive_r[1][]']").set('main positive_r_1')
        #show desc resourse
        expect(page).to have_selector('#desc_positive_r_1', visible: false)
        first(:css, "#main_positive_r_1 button[id='desc_to_res']").click
        expect(page).to have_selector('#desc_positive_r_1', visible: true)
        first(:css, "#main_positive_r_1 textarea[name='res_positive_r[1][]']").set('desc positive_r_1')

        find(:css, "#main_positive_s_1 input.autocomplete[name='resor_positive_s[1][]']").set('main positive_s_1 first')
        #show desc mean
        expect(page).to have_selector('#desc_positive_s_1', visible: false)
        first(:css, "#main_positive_s_1 button[id='desc_to_res']").click
        expect(page).to have_selector('#desc_positive_s_1', visible: true)
        first(:css, "#main_positive_s_1 textarea[name='res_positive_s[1][]']").set('desc positive_s_1 first')

        #plus mean
        first(:css, "#main_positive_r_1 button[id='plus_mean']").click
        expect(page).to have_selector '#main_positive_s_1', count: 2
        find(:xpath, "//div[@id=\"main_positive_s_1\"][2]//input[@name=\"resor_positive_s[1][]\"]").set('main positive_s_1 second')
        find(:xpath, "//div[@id=\"main_positive_s_1\"][2]//button[@id=\"desc_to_res\"]").click
        find(:xpath, "//div[@id=\"main_positive_s_1\"][2]//textarea[@name=\"res_positive_s[1][]\"]").visible? == true
        find(:xpath, "//div[@id=\"main_positive_s_1\"][2]//textarea[@name=\"res_positive_s[1][]\"]").set('desc positive_s_1 second')

        #add resource
        expect(page).to have_selector '#add_positive_r', 'Добавить ресурс'
        find("#add_positive_r").click
        expect(page).to have_selector '#main_positive_r_2'
        #show desc resourse
        find(:css, "#main_positive_r_2 input.autocomplete[name='resor_positive_r[2][]']").set('main positive_r_2')
        expect(page).to have_selector('#desc_positive_r_2', visible: false)
        first(:css, "#main_positive_r_2 button[id='desc_to_res']").click
        expect(page).to have_selector('#desc_positive_r_2', visible: true)
        first(:css, "#main_positive_r_2 textarea[name='res_positive_r[2][]']").set('desc positive_r_2')
        #plus mean
        first(:css, "#main_positive_r_2 button[id='plus_mean']").click
        expect(page).to have_selector '#main_positive_s_2'
        find(:css, "#main_positive_s_2 input.autocomplete[name='resor_positive_s[2][]']").set('main positive_s_2')
        first(:css, "#main_positive_s_2 button[id='desc_to_res']").click
        expect(page).to have_selector('#desc_positive_s_2', visible: true)
        first(:css, "#main_positive_r_2 textarea[name='res_positive_s[2][]']").set('desc positive_s_2')

        #destroy element
        find("#add_positive_r").click
        expect(page).to have_selector '#main_positive_r_3'
        first(:css, "#main_positive_r_3 button[id='plus_mean']").click
        expect(page).to have_selector '#main_positive_s_3'
        first(:css, "#main_positive_s_3 button[id='destroy_res']").click
        expect(page).not_to have_selector '#main_positive_s_3'
        first(:css, "#main_positive_r_3 button[id='destroy_res']").click
        expect(page).not_to have_selector '#main_positive_r_3'

        click_button 'send_post_concept'
        expect(page).to have_content 'Ваше нововведение успешно добавлено! Вы можете добавить еще одно или перейти к просмотру списка нововведений.'
        expect(page).to have_content 'Перейти к списку'
        expect(page).to have_content 'Добавить еще одно'
        click_link 'Перейти к списку'
        expect(page).to have_content 'con title'
        click_link 'con title'
        expect(page).to have_content 'con title'
        expect(page).to have_content 'main positive_r_1'
        #expect(page).to have_content 'desc positive_r_1'
        expect(page).to have_content 'main positive_s_1 first'
        expect(page).to have_content 'desc positive_s_1 first'
        expect(page).to have_content 'main positive_s_1 second'
        expect(page).to have_content 'desc positive_s_1 second'
        expect(page).to have_content 'main positive_r_2'
        expect(page).to have_content 'desc positive_r_2'
        expect(page).to have_content 'main positive_s_2'
        expect(page).to have_content 'desc positive_s_2'
      end

      it ' add new empty concept with error', js: true do
        click_link "new_concept_#{@discontent1.id}"
        expect(page).to have_content 'Краткое название вашего нововведения'
        expect(page).to have_content @discontent1.content
        click_button 'send_post_concept'
        expect(page).to have_content 'Сохранение не удалось из-за 2 ошибок:'
        expect(page).to have_content 'Поле "Краткое название" не может быть пустым'
        expect(page).to have_content 'Поле "A1" не может быть пустым'
        #expect(page).to have_content 'Поле "A2" не может быть пустым'
        fill_in "pa_title", with: 'con title'
        fill_in "pa_name", with: 'con name'
        #fill_in "pa_content", with: 'con content'
        click_button 'send_post_concept'
        expect(page).to have_content 'Ваше нововведение успешно добавлено!'
        expect(page).to have_content 'Перейти к списку'
        expect(page).to have_content 'Добавить еще одно'
      end
    end

    context 'show concept'   do
      before do
        visit concept_post_path(project, @concept1)
      end

      it 'can see right form' do
        #save_and_open_page
        expect(page).to have_content @discontent1.content
        expect(page).to have_content @concept_aspect1.title
        expect(page).to have_content @concept_aspect1.name
        expect(page).to have_content @concept_aspect1.positive
        expect(page).to have_content @concept_aspect1.negative
        expect(page).to have_content @concept_aspect1.content
        expect(page).to have_content @concept_aspect1.control
        expect(page).to have_content @concept_aspect1.obstacles
        expect(page).to have_content @concept_aspect1.reality
        expect(page).to have_content @concept_aspect1.problems
        expect(page).to have_selector 'textarea#comment_text_area'
        expect(page).not_to have_link("plus_post_#{@concept1.id}", :text => 'Выдать баллы', :href => plus_concept_post_path(project,@concept1))
      end

      it ' can add comments ', js: true do
        fill_in 'comment_text_area', with: 'con comment 1'
        click_button 'send_post'
        expect(page).to have_content 'con comment 1'
      end
      it ' add new answer comment', js: true do
        click_link "add_child_comment_#{@comment1.id}"
        find("#child_comments_form_#{@comment1.id}").find('#comment_text_area').set "new child comment"
        find("#child_comments_form_#{@comment1.id}").find('#send_post').click
        expect(page).to have_content 'new child comment'
      end
    end

    context 'vote discontent '   do
      before do
        project.update_attributes(:status => 8)
        visit concept_posts_path(project)
      end

      it 'have content ', js:true do
        expect(page).to have_content 'Голосование за нововведения'
        expect(page).to have_content @discontent1.content
        expect(page).to have_content 'Пара: 1 из 1'
        expect(page).to have_content 'Нововведение 1'
        expect(page).to have_content @concept_aspect1.title
        expect(page).to have_content 'Нововведение 2'
        expect(page).to have_content @concept_aspect2.title
        expect(page).to have_selector '#btn_vote_1', 'Нововведение 1'
        expect(page).to have_selector '#btn_vote_2', 'Нововведение 2'
        click_link "btn_vote_1"
        expect(page).to have_content 'Спасибо за участие в голосовании!'
        expect(page).to have_selector 'a', 'Перейти к рефлексии'
        expect(page).to have_selector 'a', 'Перейти к списку нововведений'
        click_link "Перейти к списку нововведений"
        expect(page).to have_content 'Нововведения'
        expect(page).to have_content 'Неоформленные идеи'
      end
    end
  end

  context 'moderator sign in' do
    before do
      sign_in moderator
      visit root_path
    end

    context 'concept list' do
      before do
        visit concept_posts_path(project)
      end

      it ' can see all concepts in aspect' do
        #save_and_open_page
        expect(page).to have_content 'Нововведения'
        expect(page).to have_content 'Неоформленные идеи'
        expect(page).to have_content @discontent1.content
        expect(page).to have_content @discontent2.content
        expect(page).to have_content @concept_aspect1.title
        expect(page).to have_content @concept_aspect2.title
        expect(page).to have_selector "#new_concept_#{@discontent1.id}"
        expect(page).to have_selector "#new_concept_#{@discontent2.id}"
      end

      it ' add new concept', js: true do
        click_link "new_concept_#{@discontent1.id}"
        expect(page).to have_content 'Краткое название вашего нововведения'
        expect(page).to have_content @discontent1.content
        fill_in "pa_title", with: 'con title'
        fill_in "pa_name", with: 'con name'
        fill_in "pa_content", with: 'con content'
        fill_in "pa_positive", with: 'con positive'
        fill_in "pa_negative", with: 'con negative'
        fill_in "pa_control", with: 'con control'
        fill_in "pa_obstacles", with: 'con obstacles'
        fill_in "pa_reality", with: 'con reality'
        fill_in "pa_problems", with: 'con problems'
        click_button 'send_post_concept'
        expect(page).to have_content 'Ваше нововведение успешно добавлено! Вы можете добавить еще одно или перейти к просмотру списка нововведений.'
        expect(page).to have_content 'Перейти к списку'
        expect(page).to have_content 'Добавить еще одно'
        click_link 'Перейти к списку'
        expect(page).to have_content 'con title'
      end
    end

    context 'show concept'   do
      before do
        visit concept_post_path(project, @concept1)
      end

      it 'can see right form' do
        #save_and_open_page
        expect(page).to have_content @discontent1.content
        expect(page).to have_content @concept_aspect1.title
        expect(page).to have_content @concept_aspect1.name
        expect(page).to have_content @concept_aspect1.positive
        expect(page).to have_content @concept_aspect1.negative
        expect(page).to have_content @concept_aspect1.content
        expect(page).to have_content @concept_aspect1.control
        expect(page).to have_content @concept_aspect1.obstacles
        expect(page).to have_content @concept_aspect1.reality
        expect(page).to have_content @concept_aspect1.problems
        expect(page).to have_selector 'textarea#comment_text_area'
        expect(page).to have_link("plus_post_#{@concept1.id}", :text => 'Выдать баллы', :href => plus_concept_post_path(project,@concept1))
      end

      it ' can add comments ', js: true do
        fill_in 'comment_text_area', with: 'con comment 1'
        click_button 'send_post'
        expect(page).to have_content 'con comment 1'
      end
      it ' add new answer comment', js: true do
        click_link "add_child_comment_#{@comment1.id}"
        find("#child_comments_form_#{@comment1.id}").find('#comment_text_area').set "new child comment"
        find("#child_comments_form_#{@comment1.id}").find('#send_post').click
        expect(page).to have_content 'new child comment'
      end
      context 'like concept'   do
        before do
          prepare_awards
        end
        it ' like post', js: true do
          expect(page).to have_link("plus_post_#{@concept1.id}", :text => 'Выдать баллы', :href => plus_concept_post_path(project,@concept1))
          click_link "plus_post_#{@concept1.id}"
          expect(page).to have_link("plus_post_#{@concept1.id}", :text => 'Забрать баллы', :href => plus_concept_post_path(project,@concept1))
          click_link "plus_post_#{@concept1.id}"
          expect(page).to have_content 'Выдать баллы'
        end

        it ' like comment', js: true do
          expect(page).to have_link("plus_comment_#{@comment1.id}", :text => 'Выдать баллы', :href => plus_comment_concept_post_path(project,@comment1))
          click_link "plus_comment_#{@comment1.id}"
          expect(page).to have_link("plus_comment_#{@comment1.id}", :text => 'Забрать баллы', :href => plus_comment_concept_post_path(project,@comment1))
          click_link "plus_comment_#{@comment1.id}"
          expect(page).to have_content 'Выдать баллы'
        end
      end
    end

    context 'note for concept '   do
      before do
        visit concept_post_path(project, @concept1)
      end

      it 'can add note ', js:true do
        click_link "btn_note_1"
        #save_and_open_page
        #screenshot_and_open_image
        expect(page).to have_selector "form#note_for_post_#{@concept1.id}_1"
        find("#note_for_post_#{@concept1.id}_1").find('#edit_post_note_text_area').set "new note for first field concept post"
        find("#note_for_post_#{@concept1.id}_1").find("#send_post_1").click
        expect(page).to have_content "new note for first field concept post"
        page.execute_script %($("ul#note_form_#{@concept1.id}_1 a").click())
        # @todo нужно ждать пока отработает анимация скрытия и элемент будет удален
        sleep(5)
        expect(page).not_to have_content "new note for first field concept post"
      end

    end

    context 'vote discontent ' do
      before do
        project.update_attributes(:status => 8)
        visit concept_posts_path(project)
      end

      it 'have content ', js:true do
        expect(page).to have_content 'Голосование за нововведения'
        expect(page).to have_content @discontent1.content
        expect(page).to have_content 'Пара: 1 из 1'
        expect(page).to have_content 'Нововведение 1'
        expect(page).to have_content @concept_aspect1.title
        expect(page).to have_content 'Нововведение 2'
        expect(page).to have_content @concept_aspect2.title
        expect(page).to have_selector '#btn_vote_1', 'Нововведение 1'
        expect(page).to have_selector '#btn_vote_2', 'Нововведение 2'
        click_link "btn_vote_1"
        expect(page).to have_content 'Спасибо за участие в голосовании!'
        expect(page).to have_selector 'a', 'Перейти к рефлексии'
        expect(page).to have_selector 'a', 'Перейти к списку нововведений'
        click_link "Перейти к списку нововведений"
        expect(page).to have_content 'Нововведения'
        expect(page).to have_content 'Неоформленные идеи'
      end
    end
  end

  context 'expert sign in' do
  end

end