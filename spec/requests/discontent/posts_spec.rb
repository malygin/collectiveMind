require 'spec_helper'

describe 'Discontent ' do
  subject { page }

  let (:user) { create :user }
  let (:user_data) { create :user }
  let (:moderator) { create :moderator }
  let (:project) { create :core_project, status: 3 }
  let (:project_for_group) { create :core_project, status: 4 }

  before do
    @aspect1 = create :aspect, project: project
    @discontent1 = create :discontent, project: project, user: user, anonym: false
    create :discontent_post_aspect, post_id: @discontent1.id, aspect_id: @aspect1.id
    @discontent2 = create :discontent, project: project, user: user, anonym: false
    create :discontent_post_aspect, post_id: @discontent2.id, aspect_id: @aspect1.id
    @post1 = @discontent1
    @comment_1 = create :discontent_comment, post: @post1, user: user
    @comment_2 = create :discontent_comment, post: @post1, comment: @comment_1
  end

  context 'ordinary user sign in ' do
    before do
      sign_in user
    end

    context 'discontent list' do
      before do
        visit discontent_posts_path(project)
      end

      it ' can see all discontents in aspect' do
        visit "/project/#{project.id}/discontent/posts?asp=#{@aspect1.id}"
        expect(page).to have_content 'Несовершенства'
        expect(page).to have_content I18n.t('show.improve.problem')
        expect(page).to have_content @discontent1.content
        expect(page).to have_content @discontent2.content
        expect(page).to have_selector '#add_record'
        expect(page).not_to have_link("plus_post_#{@discontent1.id}", text: 'Выдать баллы', href: plus_discontent_post_path(project, @discontent1))
      end

      it ' add new discontent send', js: true do
        click_link 'add_record'
        fill_in 'discontent_post_content', with: 'dis content'
        fill_in 'discontent_post_whered', with: 'dis where'
        fill_in 'discontent_post_whend', with: 'dis when'
        expect(page).to have_selector 'span', 'aspect 1'
        click_button 'send_post'
        expect(page).to have_content 'Перейти к списку'
        expect(page).to have_content 'Добавить еще одно'
        click_link 'Перейти к списку'
        expect(page).to have_content 'dis content'
      end

      it 'user profile works fine after add discontent', js: true do
        click_link 'add_record'
        fill_in 'discontent_post_content', with: 'disсontent content'
        fill_in 'discontent_post_whered', with: 'disсontent where'
        fill_in 'discontent_post_whend', with: 'disсontent when'
        expect(page).to have_selector 'span', 'aspect 1'
        click_button 'send_post'
        visit user_path(id: user.id, project: project)
        click_link 'tab-imperfections'
        expect(page).to have_content 'disсontent'
      end

      it 'add anonym discontent and get fine feed', js: true do
        click_link 'add_record'

        fill_in 'discontent_post_content', with: 'disсontent content'
        fill_in 'discontent_post_whered', with: 'disсontent where'
        fill_in 'discontent_post_whend', with: 'disсontent when'
        check 'discontent_post_anonym'
        click_button 'send_post'
        sleep 2
        visit journals_path(project: project)
        expect(page).to have_content I18n.t('journal.add_anonym_discontent')
      end
    end

    context 'show discontents' do
      before do
        visit discontent_post_path(project, @discontent1)
      end

      it 'can see right form' do
        expect(page).to have_content @discontent1.content
        expect(page).to have_content @discontent1.whend
        expect(page).to have_content @discontent1.whered
        expect(page).to have_selector "span", @aspect1.content
        expect(page).to have_selector 'textarea#comment_text_area'
        expect(page).not_to have_link("plus_post_#{@discontent1.id}", text: 'Выдать баллы', href: plus_discontent_post_path(project, @discontent1))
      end

      it_behaves_like 'content with comments'
      it_behaves_like 'likes posts'
    end

    context 'vote discontent ' do
      before do
        project.update_attributes(status: 6)
        prepare_for_vote_discontents(project)
        visit discontent_posts_path(project)
      end

      it 'have content ', js: true do
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
        expect(page).to have_content I18n.t('show.improve.problem')
      end
    end
  end

  context 'moderator sign in' do
    before do
      sign_in moderator
    end

    context 'discontent list' do
      before do
        visit discontent_posts_path(project)
      end

      it ' can see all discontents in aspect' do
        visit "/project/#{project.id}/discontent/posts?asp=#{@aspect1.id}"

        expect(page).to have_content 'Несовершенства'
        expect(page).to have_content I18n.t('show.improve.problem')
        expect(page).to have_content @discontent1.content
        expect(page).to have_content @discontent2.content
        expect(page).to have_selector '#add_record'
        expect(page).to have_link("plus_post_#{@discontent1.id}", text: 'Выдать баллы', href: plus_discontent_post_path(project, @discontent1))
      end

      it 'add new discontent send', js: true do
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

    context 'show discontents' do
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

      it_behaves_like 'content with comments', true
      it_behaves_like 'likes posts', true

      context 'like concept' do
        before do
          prepare_awards
        end

        it ' like post and have award', js: true do
          expect(page).to have_link("plus_post_#{@discontent1.id}", text: 'Выдать баллы', href: plus_discontent_post_path(project, @discontent1))
          click_link "plus_post_#{@discontent1.id}"
          sleep 2
          visit journals_path(project: project)
          expect(page).to have_selector('i.fa.fa-trophy')
          visit user_path(project: project, id: user.id)
          expect(page).to have_content('25')
        end
      end
    end

    context 'note for discontent ' do
      before do
        visit discontent_posts_path(project)
      end

      it 'can add note ', js: true do
        visit "/project/#{project.id}/discontent/posts?asp=#{@aspect1.id}"
        click_link "content_dispost_what_#{@discontent1.id}"
        expect(page).to have_selector "form#note_for_post_#{@discontent1.id}_1"
        find("#note_for_post_#{@discontent1.id}_1").find('#edit_post_note_text_area').set "new note for first field discontent post"
        find("#note_for_post_#{@discontent1.id}_1").find("#send_post_#{@discontent1.id}").click
        expect(page).to have_content "new note for first field discontent post"
        page.execute_script %($("ul#note_form_#{@discontent1.id}_1 a").click())
        # @todo нужно ждать пока отработает анимация скрытия и элемент будет удален
        sleep(5)
        expect(page).not_to have_content 'new note for first field discontent post'
      end
    end

    context 'group discontent ' do
      before do
        project.update_attributes(status: 4)
        visit discontent_posts_path(project)
      end

      it 'have content ' do
        visit "/project/#{project.id}/discontent/posts?asp=#{@aspect1.id}"
        expect(page).to have_content 'Исходные'
        expect(page).to have_content 'Объединенные'
        expect(page).to have_content I18n.t('show.improve.problem')
        expect(page).to have_content 'Группы несовершенств'
        expect(page).to have_content 'Несовершенства'
        expect(page).to have_link('add_record', text: 'Добавить новую группу')
      end

      it 'add new group ', js: true do
        visit "/project/#{project.id}/discontent/posts?asp=#{@aspect1.id}"
        click_link 'add_record'
        sleep(5)
        fill_in 'discontent_post_content', with: 'new group content'
        fill_in 'discontent_post_whered', with: 'new group where'
        fill_in 'discontent_post_whend', with: 'new group when'
        click_button 'send_post'
        expect(page).to have_content 'new group content'
        expect(page).to have_content 'Разгруппировать'
        expect(page).to have_content 'Редактировать группу'
        find("#post_#{@discontent1.id} #select_for_discontents_group").find(:xpath, 'option[2]').select_option
        expect(page).to have_content 'Добавлено в группу new group content'
      end
    end

    context 'vote discontent ' do
      before do
        project.update_attributes(status: 6)
        prepare_for_vote_discontents(project)
        visit discontent_posts_path(project)
      end

      it 'have content ', js: true do
        expect(page).to have_content 'Голосование за несовершенства'
        expect(page).to have_content 'Определение наиболее важных проблем'
        expect(page).to have_content 'Несовершенство: 1 из 1'
        expect(page).to have_content @discontent_group1.content
        click_link "vote_positive_#{@discontent_group1.id}"
        expect(page).to have_content 'Спасибо за участие в голосовании!'
        expect(page).to have_selector 'a', 'Перейти к рефлексии'
        expect(page).to have_selector 'a', 'Перейти к списку несовершенств'
        click_link 'Перейти к списку несовершенств'
        expect(page).to have_content 'Несовершенства'
        expect(page).to have_content I18n.t('show.improve.problem')
      end
    end
  end
end
