require 'spec_helper'

describe 'Discontent::PostAdvices' do
  subject { page }
  let (:user) { create :user }
  let (:prime_admin) { create :prime_admin }
  let (:moderator) { create :moderator }
  let (:project) { create :core_project, status: 3 }
  let (:project_for_group) { create :core_project, status: 4 }

  before do
    prepare_discontents(project, user)
  end

  context 'ordinary user sign in ' do
    before do
      sign_in user
      visit root_path
    end

    it 'link to unapproved advices not show' do
      visit discontent_posts_path(project)
      within :css, 'ul#side-nav' do
        expect(page).not_to have_content I18n.t('left_side.discontent_post_advices')
        expect(page).not_to have_link discontent_post_advices_path(@project)
      end
    end
  end

  context 'moderator sign in' do
    before do
      sign_in moderator
      visit root_path
    end

    it 'openable link to unapproved advices' do
      visit discontent_posts_path(project)
      within :css, 'ul#side-nav' do
        expect(page).to have_content I18n.t('left_side.discontent_post_advices')
        expect(page).to have_link discontent_post_advices_path(@project)
      end
      #@todo добавить проверку на вывод количества непроверенных и открытие страницы
    end
  end
end
