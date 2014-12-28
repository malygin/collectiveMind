require 'spec_helper'

describe 'Estimate ' do
  subject { page }

  let (:user) { create :user }
  let (:project) { create :core_project, status: 10 }
  let (:prime_admin) { create :prime_admin }
  let (:moderator) { create :moderator }

  before do
    prepare_estimates(project, user)
  end

  context 'ordinary user sign in ' do
    before do
      sign_in user
      visit estimate_posts_path(project)
    end

    context 'estimate list' do
      it ' can see estimate' do
        #save_and_open_page
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

    context 'estimate edit' do
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

      it 'can see second tab', js: true do
        find("li#second a").click
        sleep(5)
        expect(page).to have_content @plan_aspect1.title
        expect(page).to have_content @plan_aspect1.name
        expect(page).to have_content @plan_stage1.name
        expect(page).to have_content @plan_stage1.desc
        expect(page).to have_content @plan_action1.name
        expect(page).to have_content @plan_action1.desc
      end

      it 'can see third tab', js: true do
        find("li#third a").click
        sleep(5)
        expect(page).to have_content @plan_aspect1.title
      end
    end
  end

  context 'moderator sign in ' do
    before do
      sign_in moderator
      visit estimate_posts_path(project)
    end

    context 'estimate list' do
      it ' can see estimate' do
        #save_and_open_page
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

    context 'estimate edit' do
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

      it 'can see second tab', js: true do
        find("li#second a").click
        sleep(5)
        expect(page).to have_content @plan_aspect1.title
        expect(page).to have_content @plan_aspect1.name
        expect(page).to have_content @plan_stage1.name
        expect(page).to have_content @plan_stage1.desc
        expect(page).to have_content @plan_action1.name
        expect(page).to have_content @plan_action1.desc
      end

      it 'can see third tab', js: true do
        find("li#third a").click
        sleep(5)
        expect(page).to have_content @plan_aspect1.title
      end
    end
  end
end
