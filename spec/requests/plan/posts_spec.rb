require 'spec_helper'

describe 'Plan ' do
  subject { page }

  let!(:user) { @user = create :user }
  let (:user_data) { create :user }
  let!(:moderator) { @moderator = create :moderator }
  let (:project) { @project = create :closed_project, stage: '5:0' }

  before do
    create :core_project_user, user: user, core_project: project
    create :core_project_user, user: moderator, core_project: project

    @user_check = create :user_check, user: user, project: project, check_field: 'plan_posts_intro'
    @moderator_check = create :user_check, user: moderator, project: project, check_field: 'plan_posts_intro'

    @user_check_popover = create :user_check, user: user, project: project, check_field: 'plan_discuss'
    @moderator_check_popover = create :user_check, user: moderator, project: project, check_field: 'plan_discuss'

    @novation1 = create :novation, user: user, project: project

    @plan1 = create :plan, user: user, project: project, status: 1
    @plan2 = create :plan, user: user, project: project, status: 1

    create :plan_novation, plan_post: @plan1, novation_post: @novation1
    create :plan_novation, plan_post: @plan2, novation_post: @novation1

    @post1 = @plan1
    @post2 = @plan2

    @comment_1 = create :plan_comment, post: @post1, user: user
    @comment_2 = create :plan_comment, post: @post1, comment: @comment_1
  end

  shared_examples 'show list plans' do
    before do
      visit plan_posts_path(project)
    end

    it 'have content', js: true do
      expect(page).to have_content 'Проектные предложения (2)'
      expect(page).to have_content @plan1.content
      expect(page).to have_content @plan2.content
    end

    it_behaves_like 'likes posts'
  end

  shared_examples 'discuss plans' do
    before do
      visit plan_posts_path(project)
    end

    it 'have content' do
      expect(page).to have_content 'Проектные предложения (2)'
      expect(page).to have_content @plan1.content
      expect(page).to have_content @plan2.content
      expect(page).to have_link 'new_plan_posts'
    end

    context 'show popup plan ', js: true do
      before do
        find(:css, "#show_record_#{@post1.id}").trigger('click')
      end

      it 'have content' do
        expect(page).to have_content @post1.name
      end

      it_behaves_like 'content with comments'
    end
  end

  context 'ordinary user sign in ' do
    before do
      sign_in user
    end

    it_behaves_like 'welcome popup', 'plan'

    it_behaves_like 'show list plans'

    it_behaves_like 'admin panel post'

    it_behaves_like 'discuss plans'
  end

  context 'moderator sign in ' do
    before do
      sign_in moderator
    end

    it_behaves_like 'admin panel post', true

    # it_behaves_like 'welcome popup', 'plan'
    #
    # it_behaves_like 'show list plans'
    #
    # it_behaves_like 'sort plans'
    #
    # it_behaves_like 'discuss plans'
  end

end
