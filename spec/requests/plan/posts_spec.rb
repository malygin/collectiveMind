require 'spec_helper'

describe 'Plan ', skip: true do
  subject { page }

  let!(:user) { @user = create :user }
  let (:user_data) { create :user }
  let!(:moderator) { @moderator = create :moderator }
  let (:project) { @project = create :closed_project, status: 11 }

  before do
    create :core_project_user, user: user, core_project: project
    create :core_project_user, user: moderator, core_project: project

    @user_check = create :user_check, user: user, project: project, check_field: 'plan_intro'
    @moderator_check = create :user_check, user: moderator, project: project, check_field: 'plan_intro'

    @novation1 = create :novation, user: user, project: project

    @plan1 = create :plan, user: user, project: project
    @plan2 = create :plan, user: user, project: project

    create :plan_novation, plan_post: @plan1.id, novation_post: @novation1.id
    create :plan_novation, plan_post: @plan2.id, novation_post: @novation1.id

    @post1 = @novation1
    @post2 = @novation2

    @comment_1 = create :plan_comment, post: @post1, user: user
    @comment_2 = create :plan_comment, post: @post1, comment: @comment_1
  end

  shared_examples 'show list plans' do
    before do
      visit plan_posts_path(project)
    end

    it 'have content', js: true do
      expect(page).to have_content 'Проектные предложения (2)'
      expect(page).to have_content @plan1.name
      expect(page).to have_content @plan2.name
    end

    it_behaves_like 'likes posts'
  end

  shared_examples 'sort plans' do
    before do
      visit plan_posts_path(project)
    end

    it 'can sort to date' do
      find(:css, "span#sorter span.sort-1").trigger('click')
      sleep(5)
      first(:css, "#tab_novation_plans .plan-block .media-body a").click
      expect(page).to have_content @plan1.name
    end

    it 'can sort to popular' do
      find(:css, "span#sorter span.sort-2").trigger('click')
      sleep(5)
      first(:css, "#tab_novation_plans .plan-block .media-body a").click
      expect(page).to have_content @plan2.name
    end
  end

  shared_examples 'discuss plans' do
    before do
      visit plan_posts_path(project)
    end

    it 'have content' do
      expect(page).to have_content 'Проектные предложения (2)'
      expect(page).to have_content @plan1.name
      expect(page).to have_content @plan2.name
      expect(page).to have_link 'add_record'
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

    it_behaves_like 'sort plans'

    it_behaves_like 'discuss plans'
  end

  # context 'moderator sign in ' do
  #   before do
  #     sign_in moderator
  #   end
  #
  #
  # it_behaves_like 'welcome popup', 'plan'
  #
  # it_behaves_like 'show list plans'
  #
  # it_behaves_like 'sort plans'
  #
  # it_behaves_like 'discuss plans'
  # end

end
