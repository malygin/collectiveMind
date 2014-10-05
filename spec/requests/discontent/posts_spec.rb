# encoding: utf-8
require 'spec_helper'
describe 'Discontent ' do
  subject { page }
  # screenshot_and_open_image
  # save_and_open_page
  let (:user) {create :user }
  let (:prime_admin) {create :prime_admin }
  let (:moderator) {create :moderator }
  let (:project) {create :core_project, status: 3 }
  let (:project_for_group) {create :core_project, status: 4 }

  before  do
    prepare_discontents(project,user)
  end

  context  'ordinary user sign in ' do
    before do
      sign_in user
      visit root_path
    end

    context 'discontent list' do
      before do
        visit discontent_posts_path(project)
      end

      it ' can see all discontents in aspect' do
        expect(page).to have_content 'Несовершенства'
        expect(page).to have_content 'Неоформленные проблемы'
        expect(page).to have_content @discontent1.content
        expect(page).to have_content @discontent2.content
        expect(page).to have_selector '#add_record'
        expect(page).not_to have_link("plus_post_#{@discontent1.id}", :text => 'Выдать баллы', :href => plus_discontent_post_path(project,@discontent1))
      end

      it ' add new discontent send', js: true do
        click_link 'add_record'
        fill_in 'discontent_post_content', with: 'dis content'
        fill_in 'discontent_post_whered', with: 'dis where'
        fill_in 'discontent_post_whend', with: 'dis when'
        #screenshot_and_open_image
        expect(page).to have_selector "span", 'aspect 1'
        #select('aspect 1', :from => 'select_for_aspects')
        click_button 'send_post'
        expect(page).to have_content 'Перейти к списку'
        expect(page).to have_content 'Добавить еще одно'
        click_link 'Перейти к списку'
        expect(page).to have_content 'dis content'
      end
    end

    context 'show discontents'   do
      before do
        visit discontent_post_path(project, @discontent1)
      end

      it 'can see right form' do
        #save_and_open_page
        expect(page).to have_content @discontent1.content
        expect(page).to have_content @discontent1.whend
        expect(page).to have_content @discontent1.whered
        expect(page).to have_selector "span", 'aspect 1'
        expect(page).to have_selector 'textarea#comment_text_area'
        expect(page).not_to have_link("plus_post_#{@discontent1.id}", :text => 'Выдать баллы', :href => plus_discontent_post_path(project,@discontent1))
      end

      it ' can add  comments ', js: true  do
        fill_in 'comment_text_area', with: 'dis comment 1'
        click_button 'send_post'
        expect(page).to have_content 'dis comment 1'
      end

      it ' add new answer comment', js: true do
        click_link "add_child_comment_#{@comment1.id}"
        #fill_in 'comment_text_area', with: 'new comment'
        #find('#comment_text_area').set('new child comment')
        find("#child_comments_form_#{@comment1.id}").find('#comment_text_area').set "new child comment"
        find("#child_comments_form_#{@comment1.id}").find('#send_post').click
        expect(page).to have_content 'new child comment'
        #screenshot_and_open_image
      end
    end

    context 'vote discontent '   do
      before do
        project.update_attributes(:status => 6)
        prepare_for_vote_discontents(project)
        visit discontent_posts_path(project)
      end

      it 'have content ', js:true do
        #expect(page).to have_content '2 этап: Сбор несовершенств. Голосование'
        expect(page).to have_content 'Голосование за несовершенства'
        expect(page).to have_content 'Определение наиболее важных проблем'
        expect(page).to have_content 'Несовершенство: 1 из 1'
        expect(page).to have_content @discontent_group1.content
        click_link "vote_positive_#{@discontent_group1.id}"
        expect(page).to have_content 'Спасибо за участие в голосовании!'
        expect(page).to have_selector 'a', 'Перейти к рефлексии'
        expect(page).to have_selector 'a', 'Перейти к списку несовершенств'
        click_link "Перейти к списку несовершенств"
        expect(page).to have_content 'Несовершенства'
        expect(page).to have_content 'Неоформленные проблемы'
      end
    end

  end

  context 'moderator sign in' do
    before do
      sign_in moderator
      visit root_path
    end

    context 'discontent list' do
      before do
        visit discontent_posts_path(project)
      end

      it ' can see all discontents in aspect' do
        expect(page).to have_content 'Несовершенства'
        expect(page).to have_content 'Неоформленные проблемы'
        expect(page).to have_content @discontent1.content
        expect(page).to have_content @discontent2.content
        expect(page).to have_selector '#add_record'
        expect(page).to have_link("plus_post_#{@discontent1.id}", :text => 'Выдать баллы', :href => plus_discontent_post_path(project,@discontent1))
      end

      it ' add new discontent send', js: true do
        click_link 'add_record'
        fill_in 'discontent_post_content', with: 'dis content'
        fill_in 'discontent_post_whered', with: 'dis where'
        fill_in 'discontent_post_whend', with: 'dis when'
        expect(page).to have_selector "span", 'aspect 1'
        click_button 'send_post'
        expect(page).to have_content 'Перейти к списку'
        expect(page).to have_content 'Добавить еще одно'
        click_link 'Перейти к списку'
        expect(page).to have_content 'dis content'
      end
    end

    context 'show discontents'   do
      before do
        visit discontent_post_path(project, @discontent1)
      end

      it 'can see right form' do
        expect(page).to have_content @discontent1.content
        expect(page).to have_content @discontent1.whend
        expect(page).to have_content @discontent1.whered
        expect(page).to have_selector "span", 'aspect 1'
        expect(page).to have_selector 'textarea#comment_text_area'
      end

      it ' can add  comments ', js: true  do
        fill_in 'comment_text_area', with: 'dis comment 1'
        click_button 'send_post'
        expect(page).to have_content 'dis comment 1'
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
          expect(page).to have_link("plus_post_#{@discontent1.id}", :text => 'Выдать баллы', :href => plus_discontent_post_path(project,@discontent1))
          click_link "plus_post_#{@discontent1.id}"
          expect(page).to have_link("plus_post_#{@discontent1.id}", :text => 'Забрать баллы', :href => plus_discontent_post_path(project,@discontent1))
          click_link "plus_post_#{@discontent1.id}"
          expect(page).to have_content 'Выдать баллы'
        end

        it ' like comment', js: true do
          expect(page).to have_link("plus_comment_#{@comment1.id}", :text => 'Выдать баллы', :href => plus_comment_discontent_post_path(project,@comment1))
          click_link "plus_comment_#{@comment1.id}"
          expect(page).to have_link("plus_comment_#{@comment1.id}", :text => 'Забрать баллы', :href => plus_comment_discontent_post_path(project,@comment1))
          click_link "plus_comment_#{@comment1.id}"
          expect(page).to have_content 'Выдать баллы'
        end
      end

    end

    context 'note for discontent '   do
      before do
        visit discontent_posts_path(project)
      end

      it 'can add note ', js:true do
        click_link "content_dispost_what_#{@discontent1.id}"
        expect(page).to have_selector "form#note_for_post_what_#{@discontent1.id}"
        find("#note_for_post_what_#{@discontent1.id}").find('#edit_post_note_text_area').set "new note for first field discontent post"
        find("#note_for_post_what_#{@discontent1.id}").find("#send_post_#{@discontent1.id}").click
        expect(page).to have_content "new note for first field discontent post"
        page.execute_script %($("ul#note_form_what_#{@discontent1.id} a").click())
        # @todo нужно ждать пока отработает анимация скрытия и элемент будет удален
        sleep(5)
        expect(page).not_to have_content "new note for first field discontent post"
      end

    end

    context 'group discontent '   do
      before do
        project.update_attributes(:status => 4)
        visit discontent_posts_path(project)
      end

      it 'have content ' do
        expect(page).to have_content 'Исходные'
        expect(page).to have_content 'Объединенные'
        expect(page).to have_content 'Неоформленные проблемы'
        expect(page).to have_content 'Группы несовершенств'
        expect(page).to have_content 'Несовершенства'
        expect(page).to have_link('add_record', :text => 'Добавить новую группу', :href => discontent_posts_new_group_path(project))
      end

      it 'add new group ', js:true do
        click_link "add_record"
        fill_in 'discontent_post_content', with: 'new group content'
        fill_in 'discontent_post_whered', with: 'new group where'
        fill_in 'discontent_post_whend', with: 'new group when'
        page.select('aspect 1', :from => 'select_for_aspects')
        click_button 'send_post'
        expect(page).to have_content 'new group content'
        expect(page).to have_content 'Разгруппировать'
        expect(page).to have_content 'Редактировать группу'
        #page.select('new group content', :from => find("#post_#{@discontent1.id} #select_for_discontents_group"))
        find("#post_#{@discontent1.id} #select_for_discontents_group").find(:xpath, 'option[2]').select_option
        expect(page).to have_content 'Добавлено в группу new group content'
      end
    end

    context 'vote discontent '   do
      before do
        project.update_attributes(:status => 6)
        prepare_for_vote_discontents(project)
        visit discontent_posts_path(project)
      end

      it 'have content ', js:true do
        #expect(page).to have_content '2 этап: Сбор несовершенств. Голосование'
        expect(page).to have_content 'Голосование за несовершенства'
        expect(page).to have_content 'Определение наиболее важных проблем'
        expect(page).to have_content 'Несовершенство: 1 из 1'
        expect(page).to have_content @discontent_group1.content
        click_link "vote_positive_#{@discontent_group1.id}"
        expect(page).to have_content 'Спасибо за участие в голосовании!'
        expect(page).to have_selector 'a', 'Перейти к рефлексии'
        expect(page).to have_selector 'a', 'Перейти к списку несовершенств'
        click_link "Перейти к списку несовершенств"
        expect(page).to have_content 'Несовершенства'
        expect(page).to have_content 'Неоформленные проблемы'
      end
    end

  end

  context 'expert sign in' do
  end

end