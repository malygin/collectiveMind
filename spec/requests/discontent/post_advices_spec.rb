require 'spec_helper'

describe 'Discontent::PostAdvices' do
  subject { page }
  let (:user) { create :user }
  let (:moderator) { create :moderator }
  let (:project) { create :core_project, status: 3 }

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
      text_advice = 'Очень хороший совет'
      visit discontent_post_path(project, @discontent1)
      expect {
        fill_in 'discontent_post_advice_content', with: text_advice
        click_button 'send_advice'
        expect(page).to have_content I18n.t('discontent.advice_success_created')
        expect(page).to have_content text_advice
      }.to change(Discontent::PostAdvice.unapproved, :count).by(1)
    end

    context 'remove' do
      it 'if author - ok', js: true do
        advice = create :advice, user: user, discontent_post: @discontent1
        visit discontent_post_path(project, @discontent1)
        expect {
          click_link "remove_advice_#{advice.id}"
          page.driver.browser.accept_js_confirms
          expect(page).not_to have_content advice.content
        }.to change(Discontent::PostAdvice, :count).by(-1)
      end

      it 'others - no' do
        advice = create :advice, user: moderator, discontent_post: @discontent1
        visit discontent_post_path(project, @discontent1)
        expect(page).not_to have_link "remove_advice_#{advice.id}"
      end
    end
  end

  context 'moderator sign in' do
    before do
      @advice = create :advice, user: user, discontent_post: @discontent1
      sign_in moderator
      visit discontent_post_advices_path(project)
    end

    it 'link to list unapproved advices (with count of it)' do
      within :css, 'ul#side-nav' do
        expect(page).to have_content I18n.t('left_side.discontent_post_advices')
      end
      within :css, 'a#open_unapproved_advices' do
        expect(page).to have_content '(1)'
      end
    end

    it 'list unapproved advices' do
      click_link 'open_unapproved_advices'
      expect(current_path) == discontent_post_advice_path(project, @advice)
      expect(page).to have_content @advice.content
      expect(page).to have_content @advice.user
    end

    it 'approve advice', js: true do
      expect {
        click_link "approve_advice_#{@advice.id}"
        expect(page).to have_content I18n.t('discontent.advice_success_approved')
        expect(page).not_to have_content @advice.content
      }.to change(Discontent::PostAdvice.unapproved, :count).by(-1)
    end

    it 'delete any advice', js: true do
      expect {
        click_link "remove_advice_#{@advice.id}"
        page.driver.browser.accept_js_confirms
        expect(page).not_to have_content @advice.content
      }.to change(Discontent::PostAdvice.unapproved, :count).by(-1)
    end

    context 'discuss with author advice'
  end
end
