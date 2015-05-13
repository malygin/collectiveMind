require 'spec_helper'

describe 'Discontent', skip: true do
  subject { page }

  let!(:user) { @user = create :user }
  let (:user_data) { create :user }
  let!(:moderator) { @moderator = create :moderator }
  let (:project) { @project = create :closed_project, status: 3 }

  before do
    create :core_project_user, user: user, core_project: project
    create :core_project_user, user: moderator, core_project: project

    @user_check = create :user_check, user: user, project: project, check_field: 'discontent_intro'
    @moderator_check = create :user_check, user: moderator, project: project, check_field: 'discontent_intro'

    @aspect1 = create :aspect, project: project

    @discontent1 = create :discontent, project: project, user: user
    create :discontent_post_aspect, post_id: @discontent1.id, aspect_id: @aspect1.id
    @discontent2 = create :discontent, project: project, user: user
    create :discontent_post_aspect, post_id: @discontent2.id, aspect_id: @aspect1.id

    @post1 = @discontent1
    @post2 = @discontent2

    @comment_1 = create :discontent_comment, post: @post1, user: user
    @comment_2 = create :discontent_comment, post: @post1, comment: @comment_1
  end

  shared_examples 'show list discontents' do
    before do
      visit discontent_posts_path(project)
    end

    it 'have content', js: true do
      expect(page).to have_content 'Несовершенства (2)'
      expect(page).to have_content @discontent1.content
      expect(page).to have_content @discontent2.content
    end

    it_behaves_like 'likes posts'
  end

  shared_examples 'filter discontents' do
    before do
      #create new aspect
      @aspect2 = create :aspect, project: project
      @discontent3 = create :discontent, project: project, user: user
      create :discontent_post_aspect, post_id: @discontent3.id, aspect_id: @aspect2.id

      visit discontent_posts_path(project)
    end

    it 'can see all discontents' do
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
      first(:css, "#tab_aspect_posts .discontent-block .what a").click
      expect(page).to have_content @discontent1.content
    end

    it 'can sort to popular' do
      find(:css, "span#sorter span.sort-2").trigger('click')
      sleep(5)
      first(:css, "#tab_aspect_posts .discontent-block .what a").click
      expect(page).to have_content @discontent2.content
    end
  end

  shared_examples 'discuss discontents' do
    before do
      visit discontent_posts_path(project)
    end

    it 'have content' do
      expect(page).to have_content 'Несовершенства (2)'
      expect(page).to have_content @discontent1.content
      expect(page).to have_content @discontent2.content
      expect(page).to have_link 'add_record'
    end

    context 'show popup aspect ', js: true do
      before do
        find(:css, "#show_record_#{@post1.id}").trigger('click')
      end

      it 'have content' do
        expect(page).to have_content @post1.content
        expect(page).to have_content @post1.what
        expect(page).to have_content @post1.whend
        expect(page).to have_content @post1.whered
        expect(page).to have_content @aspect1.content
      end

      it_behaves_like 'content with comments'
    end
  end

  context 'ordinary user sign in ' do
    before do
      sign_in user
    end

    it_behaves_like 'welcome popup', 'discontent'

    it_behaves_like 'show list discontents'

    it_behaves_like 'filter discontents'

    it_behaves_like 'sort discontents'

    it_behaves_like 'discuss discontents'

    it_behaves_like 'vote popup', 6, 'Голосование по несовершенствам'
  end

  # context 'moderator sign in ' do
  #   before do
  #     sign_in moderator
  #   end
  #
  # it_behaves_like 'welcome popup', 'discontent'
  #
  # it_behaves_like 'show list discontents'
  #
  # it_behaves_like 'filter discontents'
  #
  # it_behaves_like 'sort discontents'
  #
  # it_behaves_like 'discuss discontents'
  #
  # it_behaves_like 'vote popup', 6, 'Голосование по несовершенствам'
  # end


end
