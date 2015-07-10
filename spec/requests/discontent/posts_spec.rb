require 'spec_helper'

describe 'Discontent' do
  subject { page }

  let!(:user) { @user = create :user }
  let (:user_data) { create :user }
  let!(:moderator) { @moderator = create :moderator }
  let (:project) { @project = create :closed_project, stage: '2:0' }

  before do
    create :core_project_user, user: user, core_project: project
    create :core_project_user, user: moderator, core_project: project

    @user_check = create :user_check, user: user, project: project, check_field: 'discontent_intro'
    @moderator_check = create :user_check, user: moderator, project: project, check_field: 'discontent_intro'

    @user_check_popover = create :user_check, user: user, project: project, check_field: 'discontent_discuss'
    @moderator_check_popover = create :user_check, user: moderator, project: project, check_field: 'discontent_discuss'

    @aspect1 = create :aspect, project: project

    @discontent1 = create :discontent, project: project, user: user
    create :discontent_post_aspect, post_id: @discontent1.id, aspect_id: @aspect1.id
    @discontent2 = create :discontent, project: project, user: user
    create :discontent_post_aspect, post_id: @discontent2.id, aspect_id: @aspect1.id

    @post1 = @discontent1
    @post2 = @discontent2

    @comment_1 = create :discontent_comment, post: @post1, user: user_data
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

    it 'can see all discontents', js: true do
      expect(page).to have_content @discontent1.content
      expect(page).to have_content @discontent2.content
      expect(page).to have_content @discontent3.content
    end

    it 'can select first aspect in dropdown', js: true do
      find(:css, "a.select-aspect").trigger('click')
      expect(page).to have_content @aspect1.content
      expect(page).to have_content @aspect2.content
      find(:css, "ul#filter li#button_aspect_#{@aspect1.id}").trigger('click')
      sleep(5)
      # @todo select content
      expect(page).to have_content @discontent1.content
      expect(page).to have_content @discontent2.content
      expect(page).to have_content @discontent3.content
    end

    it 'can select second aspect in dropdown', js: true do
      find(:css, "a.select-aspect").trigger('click')
      expect(page).to have_content @aspect1.content
      expect(page).to have_content @aspect2.content
      find(:css, "ul#filter li#button_aspect_#{@aspect2.id}").trigger('click')
      sleep(5)
      # @todo select content
      expect(page).to have_content @discontent1.content
      expect(page).to have_content @discontent2.content
      expect(page).to have_content @discontent3.content
    end
  end

  shared_examples 'sort discontents' do
    before do
      visit discontent_posts_path(project)
    end

    it 'can sort to comment', js: true do
      find(:css, "span#sorter span.sort-1").trigger('click')
      sleep(5)
      first(:css, "#tab_aspect_posts .discontent-block .what a").click
      expect(page).to have_content @discontent1.content
    end

    it 'can sort to date', js: true do
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

    it 'have content', js: true do
      expect(page).to have_content 'Несовершенства (2)'
      expect(page).to have_content @discontent1.content
      expect(page).to have_content @discontent2.content
      expect(page).to have_link 'new_discontent_posts'
    end

    context 'show popup discontent ', js: true do
      before do
        find(:css, "#show_record_#{@post1.id}").trigger('click')
      end

      it 'have content', js: true do
        expect(page).to have_content @post1.content
        expect(page).to have_content @post1.what
        # expect(page).to have_content @post1.whend
        # expect(page).to have_content @post1.whered
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

    it_behaves_like 'admin panel post'

    it_behaves_like 'filter discontents'

    it_behaves_like 'sort discontents'

    context 'show discuss discontents', js: true do
      it_behaves_like 'discuss discontents'
    end

    context 'vote content', js: true do
      it_behaves_like 'vote popup', '2:1', 'discontent'
    end
    it 'can see stage result for previous stage ', js: true do
      visit aspect_posts_path(project)
      click_link 'aspect_intro'
      click_link 'show_results'
      expect(page).to have_content 'Результаты стадии 1'
    end
  end

  context 'moderator sign in ' do
    before do
      sign_in moderator
    end

    it_behaves_like 'admin panel post', true

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
  end


end
