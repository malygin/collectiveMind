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
      visit discontent_posts_path(project)
    end

    context 'unapproved' do
      it 'not link in left side' do
        within :css, 'ul#side-nav' do
          expect(page).not_to have_content I18n.t('left_side.discontent_post_advices')
          expect(page).not_to have_link discontent_post_advices_path(project)
        end
      end

      it 'not available by url' do
        visit discontent_post_advices_path(project)
        expect(current_path) == discontent_posts_path(project)
      end
    end

    it 'create', js: true do
      visit discontent_post_path(project, @discontent1)
      expect {
        fill_in 'discontent_post_advice_content', with: 'Очень хороший совет'
        click_button 'send_advice'
        expect(page).to have_content I18n.t('discontent.advice_success_created')
      }.to change(Discontent::PostAdvice.unapproved, :count).by(1)
    end
  end

  context 'moderator sign in' do
    before do
      @advice = create :advice, user: user, discontent_post: @discontent1
      sign_in moderator
      visit root_path
    end

    it 'openable link to unapproved advices' do
      visit discontent_posts_path(project)
      within :css, 'ul#side-nav' do
        expect(page).to have_content I18n.t('left_side.discontent_post_advices')
      end
      within :css, 'a#open_unapproved_advices' do
        expect(page).to have_content '(1)'
      end
    end

    it 'list unapproved advices' do
      visit discontent_posts_path(project)
      click_link 'open_unapproved_advices'
      expect(current_path) == discontent_post_advice_path(project, @advice)
      expect(page).to have_content @advice.content
      expect(page).to have_content @advice.user
    end
  end
end
