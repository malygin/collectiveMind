require 'spec_helper'

describe 'Estimate ' do
  subject { page }

  let (:user) { create :user }
  let (:project) { create :core_project, status: 10 }
  let (:moderator) { create :moderator }

  before do
    @concept1 = create :concept, project: project
    @concept2 = create :concept, project: project
    @plan1 = create :plan, project: project
    @plan_stage1 = create :plan_stage, post_id: @plan1.id
    @plan_aspect1 = create :plan_aspect, plan_post_id: @plan1.id, post_stage_id: @plan_stage1.id
    @plan_action1 = create :plan_action, plan_post_aspect_id: @plan_aspect1.id

    @estimate1 = create :estimate, project: project, post_id: @plan1.id, user: user
    @estimate_aspect1 = create :estimate_aspect, post_id: @plan1.id, plan_post_aspect_id: @plan_aspect1.id
  end

  shared_examples 'estimate list' do
    before do
      visit estimate_posts_path(project)
    end

    it ' can see estimate' do
      expect(page).to have_content @estimate1.content
      expect(page).to have_content '+ Добавить оценку'
    end

    it ' can see estimate' do
      click_link '+ Добавить оценку'
      expect(page).to have_content @plan1.name
      expect(page).to have_content @plan1.goal
      expect(page).to have_content @plan1.content
      expect(page).to have_content @plan_stage1.name
    end
  end

  shared_examples 'estimate edit' do
    before do
      visit estimate_post_path(project, @estimate1)
    end

    it ' can see estimate' do
      expect(page).to have_content @plan1.name
      expect(page).to have_content @plan1.goal
      expect(page).to have_content @plan1.content
      expect(page).to have_content @plan_stage1.name
    end

    it ' can see estimate score' do
      expect(page).to have_content 'Общая оценка проекта'
      expect(page).to have_content 'максимальная оценка проекта'
      expect(page).to have_content 'ожидаемая эффективность первого шага проекта'
      expect(page).to have_content 'ожидаемая эффективность остальных этапов проекта'
      expect(page).to have_content 'ожидаемые неприятности в связи с осуществлением проекта'
      expect(page).to have_content 'Общее впечатление от проекта и рекомендации по улучшению'
      expect(page).to have_content 'Оценка проекта в целом:'
    end
  end

  context 'ordinary user sign in ' do
    before do
      sign_in user
      visit estimate_posts_path(project)
    end

    it_behaves_like 'estimate list'

    it_behaves_like 'estimate edit'
  end

  context 'moderator sign in ' do
    before do
      sign_in moderator
      visit estimate_posts_path(project)
    end

    it_behaves_like 'estimate list'

    it_behaves_like 'estimate edit'
  end
end
