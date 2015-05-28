require 'spec_helper'

describe 'Completion proc ' do
  subject { page }

  let!(:user) { @user = create :user }
  let (:user_data) { create :user }
  let!(:moderator) { @moderator = create :moderator }
  let (:project) { @project = create :closed_project, stage: '7:0' }

  before do
    create :core_project_user, user: user, core_project: project
    create :core_project_user, user: moderator, core_project: project

    project.update_attributes(completion_text: 'completion text for proc')

    @novation1 = create :novation, user: user, project: project

    @plan1 = create :plan, user: user, project: project, completion_status: true
    @plan2 = create :plan, user: user, project: project, completion_status: true

    create :plan_novation, plan_post: @plan1, novation_post: @novation1
    create :plan_novation, plan_post: @plan2, novation_post: @novation1
  end

  shared_examples 'show list completions' do
    before do
      visit completion_proc_posts_path(project)
    end

    it 'have content', js: true do
      expect(page).to have_content 'completion text for proc'
      find(:css, "#myCarousel ul.rate_buttons li[data-slide-to='1']").trigger('click')
      expect(page).to have_content @plan1.name
      expect(page).to have_content @plan1.goal
      find(:css, "#myCarousel ul.rate_buttons li[data-slide-to='2']").trigger('click')
      expect(page).to have_content @plan2.name
      expect(page).to have_content @plan2.goal
    end
  end

  shared_examples 'discuss completions' do
    before do
      visit completion_proc_posts_path(project)
    end

    context 'show popup completion ', js: true do
      before do
        find(:css, "#myCarousel ul.rate_buttons li[data-slide-to='1']").trigger('click')
        find(:css, "#show_record_#{@plan1.id}").trigger('click')
      end

      it 'have content' do
        expect(page).to have_content 'Описание проектного предложения'
        expect(page).to have_content 'График реализации проекта'
      end
    end
  end

  context 'ordinary user sign in ' do
    before do
      sign_in user
    end

    it_behaves_like 'show list completions'

    it_behaves_like 'discuss completions'
  end

  # context 'moderator sign in ' do
  #   before do
  #     sign_in moderator
  #   end
  #
  # it_behaves_like 'show list completions'
  #
  # it_behaves_like 'discuss completions'
  # end
end
