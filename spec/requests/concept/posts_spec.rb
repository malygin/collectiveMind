require 'spec_helper'

describe 'Concept ' do
  subject { page }

  let!(:user) { @user = create :user }
  let(:user_data) { create :user }
  let!(:moderator) { @moderator = create :moderator }
  let(:project) { @project = create :closed_project, stage: '3:0' }

  before do
    create :core_project_user, user: user, core_project: project
    create :core_project_user, user: moderator, core_project: project

    @user_check = create :user_check, user: user, project: project, check_field: 'concept_posts_intro'
    @moderator_check = create :user_check, user: moderator, project: project, check_field: 'concept_posts_intro'

    @user_check_popover = create :user_check, user: user, project: project, check_field: 'concept_discuss'
    @moderator_check_popover = create :user_check, user: moderator, project: project, check_field: 'concept_discuss'

    @aspect1 = create :aspect, project: project
    @discontent1 = create :discontent, project: project, status: 0
    create :discontent_post_aspect, post_id: @discontent1.id, aspect_id: @aspect1.id
    @discontent2 = create :discontent, project: project, status: 0
    create :discontent_post_aspect, post_id: @discontent2.id, aspect_id: @aspect1.id

    @concept1 = create :concept, user: user, project: project
    @concept2 = create :concept, user: user, project: project
    create :concept_post_discontent, post_id: @concept1.id, discontent_post_id: @discontent1.id
    create :concept_post_discontent, post_id: @concept2.id, discontent_post_id: @discontent1.id

    @post1 = @concept1
    @post2 = @concept2
    @comment_1 = create :concept_comment, post: @post1, user: user
    @comment_2 = create :concept_comment, post: @post1, comment: @comment_1
  end

  shared_examples 'show list concepts' do
    before do
      visit concept_posts_path(project)
    end

    it 'have content', js: true do
      expect(page).to have_content 'Идеи (2)'
      expect(page).to have_content @concept1.title
      expect(page).to have_content @concept2.title
    end

    it_behaves_like 'likes posts'
  end

  shared_examples 'filter concepts' do
    before do
      # create new concept
      @concept3 = create :concept, user: user, project: project
      create :concept_post_discontent, post_id: @concept3.id, discontent_post_id: @discontent2.id

      visit concept_posts_path(project)
    end

    it 'can see all concepts', js: true do
      expect(page).to have_content @concept1.title
      expect(page).to have_content @concept2.title
      expect(page).to have_content @concept3.title
    end

    it 'can select first discontent in slider', js: true do
      find(:css, 'span#opener').trigger('click')
      expect(page).to have_content @discontent1.content
      expect(page).to have_content @discontent2.content
      find(:css, "#slide-panel .checkox_item[data-discontent='.discontent_#{@discontent1.id}']").trigger('click')
      sleep(5)
      expect(page).to have_content @concept1.title
      expect(page).to have_content @concept2.title
      # expect(page).to have_content @concept3.title
    end

    it 'can select second discontent in slider', js: true do
      find(:css, 'span#opener').trigger('click')
      expect(page).to have_content @discontent1.content
      expect(page).to have_content @discontent2.content
      find(:css, "#slide-panel .checkox_item[data-discontent='.discontent_#{@discontent2.id}']").trigger('click')
      sleep(5)
      # expect(page).to have_content @concept1.title
      # expect(page).to have_content @concept2.title
      expect(page).to have_content @concept3.title
    end
  end

  shared_examples 'sort concepts' do
    before do
      visit concept_posts_path(project)
    end

    it 'can sort to date', js: true do
      find(:css, 'span#sorter span.sort-1').trigger('click')
      sleep(5)
      first(:css, '#tab_dispost_concepts .post-block .what a').click
      expect(page).to have_content @concept1.title
    end

    it 'can sort to popular', js: true do
      find(:css, 'span#sorter span.sort-2').trigger('click')
      sleep(5)
      first(:css, '#tab_dispost_concepts .post-block .what a').click
      expect(page).to have_content @concept2.title
    end
  end

  shared_examples 'discuss concepts' do
    before do
      visit concept_posts_path(project)
    end

    it 'have content', js: true do
      expect(page).to have_content 'Идеи (2)'
      expect(page).to have_content @concept1.title
      expect(page).to have_content @concept2.title
      expect(page).to have_link 'new_concept_posts'
    end

    context 'show popup aspect ', js: true do
      before do
        find(:css, "#show_record_#{@post1.id}").trigger('click')
      end

      it 'have content', js: true do
        expect(page).to have_content @post1.title
        expect(page).to have_content @post1.goal
        expect(page).to have_content @post1.actors
        expect(page).to have_content @post1.impact_env
        expect(page).to have_content @discontent1.content
      end

      it_behaves_like 'content with comments'
    end
  end

  context 'ordinary user sign in ' do
    before do
      sign_in user
    end

    it_behaves_like 'welcome popup', 'concept'

    it_behaves_like 'show list concepts'

    it_behaves_like 'admin panel post'

    it_behaves_like 'filter concepts'

    it_behaves_like 'sort concepts'

    it_behaves_like 'discuss concepts'

    context 'vote content', js: true do
      it_behaves_like 'vote popup', '3:1', 'concept'
    end
  end

  context 'moderator sign in ' do
    before do
      sign_in moderator
    end

    it_behaves_like 'admin panel post', true

    # it_behaves_like 'welcome popup', 'concept'
    #
    # it_behaves_like 'show list concepts'
    #
    # it_behaves_like 'filter concepts'
    #
    # it_behaves_like 'sort concepts'
    #
    # it_behaves_like 'discuss concepts'
    #
    # it_behaves_like 'vote popup', 8, 'Голосование по идеям'
  end
end
