require 'spec_helper'

describe 'Estimate ' do
  subject { page }

  let!(:user) { @user = create :user }
  let (:user_data) { create :user }
  let!(:moderator) { @moderator = create :moderator }
  let (:project) { @project = create :closed_project, stage: '6:0' }

  before do
    create :core_project_user, user: user, core_project: project
    create :core_project_user, user: moderator, core_project: project

    @user_check = create :user_check, user: user, project: project, check_field: 'estimate_intro'
    @moderator_check = create :user_check, user: moderator, project: project, check_field: 'estimate_intro'

    @user_check_popover = create :user_check, user: user, project: project, check_field: 'estimate_discuss'
    @moderator_check_popover = create :user_check, user: moderator, project: project, check_field: 'estimate_discuss'

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

  shared_examples 'show list estimates' do
    before do
      visit estimate_posts_path(project)
    end

    it 'have content', js: true do
      expect(page).to have_content 'Этот проект важен для проблемы, заданной заказчиком?'
      expect(page).to have_content 'Этот проект реализуем в предложенные сроки при наличии запланированных ресурсов с учетом рисков проекта?'
      expect(page).to have_content @plan1.name
      expect(page).to have_content @plan2.name
    end
  end

  shared_examples 'discuss estimates' do
    before do
      visit estimate_posts_path(project)
    end

    it 'have content', js: true do
      expect(page).to have_content 'Этот проект важен для проблемы, заданной заказчиком?'
      expect(page).to have_content 'Этот проект реализуем в предложенные сроки при наличии запланированных ресурсов с учетом рисков проекта?'
      expect(page).to have_content @plan1.name
      expect(page).to have_content @plan2.name
    end

    context 'show popup estimate ', js: true do
      before do
        find(:css, "#show_record_#{@post1.id}").trigger('click')
      end

      it 'have content' do
        expect(page).to have_content 'Описание проектного предложения'
        expect(page).to have_content 'График реализации проекта'
        expect(page).to have_content 'Оценки других участников'
      end
    end
  end

  shared_examples 'vote estimate' do
    before do
      visit estimate_posts_path(project)
    end

    it 'correct voted', js: true do
      expect(page).to have_selector "#progress_type_vote_1_#{@plan1.id}"
      expect(page).to have_selector "#progress_type_vote_2_#{@plan1.id}"

      find(:css, "#progress_type_vote_1_#{@plan1.id} .btn_plan_vote[data-status='5']").trigger('click')

      expect(page).not_to have_selector "#progress_type_vote_1_#{@plan1.id} .btn_plan_vote"
      expect(page).to have_selector "#progress_type_vote_1_#{@plan1.id} .progress-bar"
    end
  end

  context 'ordinary user sign in ' do
    before do
      sign_in user
    end

    it_behaves_like 'welcome popup', 'estimate'

    it_behaves_like 'show list estimates'

    it_behaves_like 'discuss estimates'
  end

  # context 'moderator sign in ' do
  #   before do
  #     sign_in moderator
  #   end
  #
  # it_behaves_like 'welcome popup', 'estimate'
  #
  # it_behaves_like 'show list estimates'
  #
  # it_behaves_like 'discuss estimates'
  # end
end
