require 'spec_helper'

describe 'Novation ' do
  subject { page }

  let!(:user) { @user = create :user }
  let (:user_data) { create :user }
  let!(:moderator) { @moderator = create :moderator }
  let (:project) { @project = create :closed_project, stage: '4:0' }

  before do
    create :core_project_user, user: user, core_project: project
    create :core_project_user, user: moderator, core_project: project

    @user_check = create :user_check, user: user, project: project, check_field: 'novation_posts_intro'
    @moderator_check = create :user_check, user: moderator, project: project, check_field: 'novation_posts_intro'

    @user_check_popover = create :user_check, user: user, project: project, check_field: 'novation_discuss'
    @moderator_check_popover = create :user_check, user: moderator, project: project, check_field: 'novation_discuss'

    @concept1 = create :concept, user: user, project: project

    @novation1 = create :novation, user: user, project: project, status: 1
    @novation2 = create :novation, user: user, project: project, status: 1

    create :novation_post_concept, post: @novation1, concept_post: @concept1
    create :novation_post_concept, post: @novation2, concept_post: @concept1

    @post1 = @novation1
    @post2 = @novation2

    @comment_1 = create :novation_comment, post: @post1, user: user
    @comment_2 = create :novation_comment, post: @post1, comment: @comment_1
  end

  shared_examples 'show list novations' do
    before do
      visit novation_posts_path(project)
    end

    it 'have content', js: true do
      expect(page).to have_content 'Пакеты идей (2)'
      expect(page).to have_content @novation1.title
      expect(page).to have_content @novation2.title
    end

    it_behaves_like 'likes posts'
  end

  shared_examples 'sort novations' do
    before do
      visit novation_posts_path(project)
    end

    it 'can sort to date', js: true do
      find(:css, "span#sorter span.sort-1").trigger('click')
      sleep(5)
      first(:css, "#tab_concept_novations .novation-block .post a").click
      expect(page).to have_content @novation1.content
    end

    it 'can sort to popular', js: true do
      find(:css, "span#sorter span.sort-2").trigger('click')
      sleep(5)
      first(:css, "#tab_concept_novations .novation-block .post a").click
      expect(page).to have_content @novation2.content
    end
  end

  shared_examples 'discuss novations' do
    before do
      visit novation_posts_path(project)
    end

    it 'have content', js: true do
      expect(page).to have_content 'Пакеты идей (2)'
      expect(page).to have_content @novation1.content
      expect(page).to have_content @novation2.content
      expect(page).to have_link 'new_novation_posts'
    end

    context 'show popup novation ', js: true do
      before do
        find(:css, "#show_record_#{@post1.id}").trigger('click')
      end

      it 'have content' do
        expect(page).to have_content @post1.title
        expect(page).to have_content @concept1.title
      end

      it_behaves_like 'content with comments'
    end
  end

  context 'ordinary user sign in ' do
    before do
      sign_in user
    end

    it_behaves_like 'welcome popup', 'novation'

    it_behaves_like 'show list novations'

    it_behaves_like 'admin panel post'

    it_behaves_like 'sort novations'

    # @todo
    # it_behaves_like 'with content questions'

    it_behaves_like 'discuss novations'

    context 'vote content', js: true do
      it_behaves_like 'vote popup', '4:1', 'novation'
    end
  end

  context 'moderator sign in ' do
    before do
      sign_in moderator
    end

    it_behaves_like 'admin panel post', true

    # it_behaves_like 'welcome popup', 'novation'
    #
    # it_behaves_like 'show list novations'
    #
    # it_behaves_like 'sort novations'
    #
    # it_behaves_like 'discuss novations'
    #
    # it_behaves_like 'vote popup', 10, 'Голосование по пакетам идей'
  end
end
