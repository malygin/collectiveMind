require 'spec_helper'

describe 'Discontent', skip: true do
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

  shared_examples 'discontent list' do
    before do
      visit discontent_posts_path(project)
    end

    it ' can see all discontents' do
      expect(page).to have_content 'Несовершенства'
      expect(page).to have_content @discontent1.content
      expect(page).to have_content @discontent2.content
      expect(page).to have_selector '#add_record'
    end

    # @todo move to cabinet
    # it ' add new discontent send', js: true do
    #   click_link 'add_record'
    #   fill_in 'discontent_post_content', with: 'dis content'
    #   fill_in 'discontent_post_whered', with: 'dis where'
    #   fill_in 'discontent_post_whend', with: 'dis when'
    #   expect(page).to have_selector "span", 'aspect 1'
    #   expect(page).to have_selector 'span', 'aspect 1'
    #   click_button 'send_post'
    #   expect(page).to have_content 'Перейти к списку'
    #   expect(page).to have_content 'Добавить еще одно'
    #   click_link 'Перейти к списку'
    #   expect(page).to have_content 'dis content'
    # end
    #
    # it 'user profile works fine after add discontent', js: true do
    #   click_link 'add_record'
    #   fill_in 'discontent_post_content', with: 'disсontent content'
    #   fill_in 'discontent_post_whered', with: 'disсontent where'
    #   fill_in 'discontent_post_whend', with: 'disсontent when'
    #   expect(page).to have_selector 'span', 'aspect 1'
    #   click_button 'send_post'
    #   visit user_path(id: user.id, project: project)
    #   click_link 'tab-imperfections'
    #   expect(page).to have_content 'disсontent'
    # end

    # it 'add anonym discontent and get fine feed' do
    #   click_link 'add_record'
    #
    #   fill_in 'discontent_post_content', with: 'disсontent content'
    #   fill_in 'discontent_post_whered', with: 'disсontent where'
    #   fill_in 'discontent_post_whend', with: 'disсontent when'
    #   find(:css, "#discontent_post_anonym[value='1']").set(true)
    #
    #   click_button 'send_post'
    #   visit journals_path(project: project)
    #   expect(page).to have_content I18n.t('journal.add_anonym_discontent')
    # end
  end

  shared_examples 'show discontents' do
    before do
      visit discontent_posts_path(project)
    end

    it 'can see popup' do
      expect(page).to have_content @discontent1.content
      expect(page).to have_content @discontent1.whend
      expect(page).to have_content @discontent1.whered
      find(:css, "a#show_record_#{@discontent1.id}").trigger('click')
      expect(page).to have_content "Несовершенство \"#{@discontent1.content}\""
      expect(page).to have_selector "div", @aspect1.content
      expect(page).to have_selector 'textarea#comment_text_area'
      expect(page).to have_content @comment_1.content
      expect(page).to have_content @comment_2.content
      expect(page).to have_link("plus_post_#{@discontent1.id}", href: like_discontent_post_path(project, @discontent1, against: false))
      expect(page).to have_link("minus_post_#{@discontent1.id}", href: like_discontent_post_path(project, @discontent1, against: true))
    end

    it_behaves_like 'content with comments'
    it_behaves_like 'likes posts'
  end

  shared_examples 'select aspect discontents' do
    before do
      #create new aspect
      @aspect2 = create :aspect, project: project
      @discontent3 = create :discontent, project: project, user: user, anonym: false
      create :discontent_post_aspect, post_id: @discontent3.id, aspect_id: @aspect2.id

      visit discontent_posts_path(project)
    end

    it 'can see all aspects' do
      expect(page).to have_content @discontent1.content
      expect(page).to have_content @discontent2.content
      expect(page).to have_content @discontent3.content
    end

    it 'can select first aspect in dropdown' do
      find(:css, "a#select-aspect").trigger('click')
      expect(page).to have_content @aspect1.content
      expect(page).to have_content @aspect2.content
      find(:css, "ul#filter li#button_aspect_#{@aspect1.id}").trigger('click')
      sleep(5)
      expect(page).to have_content @discontent1.content
      expect(page).to have_content @discontent2.content
      expect(page).not_to have_content @discontent3.content
    end

    it 'can select second aspect in dropdown' do
      find(:css, "a#select-aspect").trigger('click')
      expect(page).to have_content @aspect1.content
      expect(page).to have_content @aspect2.content
      find(:css, "ul#filter li#button_aspect_#{@aspect2.id}").trigger('click')
      sleep(5)
      expect(page).not_to have_content @discontent1.content
      expect(page).not_to have_content @discontent2.content
      expect(page).to have_content @discontent3.content
    end
  end

  shared_examples 'sort discontents' do
    before do
      visit discontent_posts_path(project)
    end

    it 'can sort to date' do
      find(:css, "span#sorter span.sort-1").trigger('click')
      sleep(5)
      first(:css, "#tab_aspect_posts discontent-block .what a").click
      expect(page).to have_content @discontent1.content
    end

    it 'can sort to popular' do
      find(:css, "span#sorter span.sort-2").trigger('click')
      sleep(5)
      first(:css, "#tab_aspect_posts discontent-block .what a").click
      expect(page).to have_content @discontent2.content
    end
  end

  context 'ordinary user sign in ' do
    before do
      sign_in user
    end

    it_behaves_like 'discontent list'

    it_behaves_like 'show discontents'

    it_behaves_like 'select aspect discontents'

    it_behaves_like 'sort discontents'
  end

  context 'moderator sign in' do
    before do
      sign_in moderator
    end

    it_behaves_like 'discontent list'

    it_behaves_like 'show discontents'

    it_behaves_like 'select aspect discontents'

    it_behaves_like 'sort discontents'

    # not functional
    # context 'like concept' do
    #   before do
    #     visit discontent_post_path(project, @discontent1)
    #     prepare_awards
    #   end
    #
    #   it ' like post and have award', js: true do
    #     expect(page).to have_css("a#plus_post_#{@comment_1.id} span", text: 'Выдать баллы')
    #
    #     find(:css, "a#plus_post_#{@discontent1.id} span").trigger('click')
    #
    #     sleep 2
    #     visit journals_path(project: project)
    #     expect(page).to have_selector('i.fa.fa-trophy')
    #     visit user_path(project: project, id: user.id)
    #     expect(page).to have_content('25')
    #   end
    # end
  end
end
