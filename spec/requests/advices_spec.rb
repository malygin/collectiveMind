require 'spec_helper'

describe 'Advices' do
  subject { page }
  let (:user) { create :user }
  let (:moderator) { create :moderator }
  let (:prime_admin) { create :prime_admin }
  let (:project) { create :core_project, status: 7, advices_concept: true, advices_discontent: true }

  before do
    prepare_concepts(project, user)
    @advice_unapproved = create :advice_unapproved, user: user, adviseable: @discontent1
    @advice = create :advice_approved, user: user, adviseable: @discontent1
  end

  context 'prime admin can setup' do
    before do
      @project = create :core_project, status: 7
      prepare_concepts(@project, user)
      sign_in prime_admin
    end

    it 'in discontents' do
      visit discontent_post_path(@project, @discontent1)
      expect(page).not_to have_content I18n.t('advice.advices')
      visit edit_core_project_path(@project)
      check 'core_project_advices_discontent'
      click_button 'send_project'

      visit discontent_post_path(@project, @discontent1)
      expect(page).to have_content I18n.t('advice.advices')
    end

    it 'in concepts' do
      visit concept_post_path(@project, @concept1)
      expect(page).not_to have_content I18n.t('advice.advices')
      visit edit_core_project_path(@project)
      check 'core_project_advices_concept'
      click_button 'send_project'

      visit concept_post_path(@project, @concept1)
      expect(page).to have_content I18n.t('advice.advices')
    end
  end

  context 'ordinary user sign in ' do
    before do
      sign_in user
      visit discontent_post_path(project, @discontent1)
    end

    context 'not view unapproved' do
      it 'not link in left side' do
        within :css, 'ul#side-nav' do
          expect(page).not_to have_content I18n.t('left_side.discontent_post_advices')
          expect(page).not_to have_link advices_path(project)
        end
      end

      it 'not available by url' do
        visit advices_path(project)
        expect(current_path) == discontent_posts_path(project)
      end

      it 'in list' do
        advice_unapproved = create :advice_unapproved, user: moderator, adviseable: @discontent1
        visit discontent_post_path(project, @discontent1)
        expect(page).not_to have_content advice_unapproved.content
        expect(page).to have_content @advice.content
      end
    end

    context 'create', js: true do
      before do
        text_advice = 'Очень хороший совет'
        fill_in 'comment_text_area', with: text_advice
        find(:css, 'label#label_advice_status').click
        click_button 'send_post'
        expect(page).to have_content I18n.t('discontent.advice_success_created')
        expect(page).to have_content text_advice
      end

      it { expect change(Advice.unapproved, :count).by(1) }

      it { expect change(Journal, :count).by(project.moderators.count) }
    end

    it 'edit', js: true do
      click_link "edit_advice_#{@advice_unapproved.id}"
      new_text_advice = 'Очень хороший совет 2'
      within :css, "#post_advice_#{@advice_unapproved.id}" do
        fill_in 'advice_content', with: new_text_advice
        click_button 'send_advice'
      end
      expect(page).to have_content new_text_advice
    end

    context 'remove' do
      it 'if author - ok', js: true do
        expect {
          click_link "remove_advice_#{@advice_unapproved.id}"
          page.driver.browser.accept_js_confirms
          expect(page).not_to have_content @advice_unapproved.content
        }.to change(Advice, :count).by(-1)
      end

      it 'others - no' do
        advice = create :advice_approved, user: moderator, adviseable: @discontent1
        visit discontent_post_path(project, @discontent1)
        expect(page).to have_content advice.content
        expect(page).not_to have_link "remove_advice_#{advice.id}"
      end
    end

    context 'set useful', js: true do
      before do
        @discontent1 = create :discontent, project: project, status: 4, user: user
        @advice_for_useful = create :advice_approved, user: moderator, adviseable: @discontent1
        visit discontent_post_path(project, @discontent1)
      end

      context 'author of post' do
        before do
          click_link "set_useful_#{@advice_for_useful.id}"
        end

        it { expect change(Advice.where(useful: true), :count).by(1) }

        it { expect change(Award, :count).by(1) }

        it { expect change(Journal, :count).by(1) }

        it 'show in notification' do
          sign_out
          sign_in moderator
          visit discontent_post_path(project, @discontent1)
          within :css, 'span.count' do
            expect(page).to have_content '1'
          end
          click_link 'messages'
          within :css, 'ul#messages-menu' do
            expect(page).to have_content @advice_for_useful.content
          end
        end
      end

      it 'not a author' do
        sign_out
        sign_in moderator
        visit discontent_post_path(project, @discontent1)
        expect(page).not_to have_link "set_useful_#{@advice_for_useful.id}"
      end
    end
  end

  context 'moderator sign in' do
    before do
      sign_in moderator
      visit advices_path(project)
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
      expect(current_path) == advices_path(project)
      expect(page).to have_content @advice_unapproved.content
      expect(page).to have_content @advice_unapproved.user
    end

    context 'approve', js: true do
      before do
        click_link "approve_advice_#{@advice_unapproved.id}"
      end

      it { expect(page).to have_content I18n.t('discontent.advice_success_approved') }

      it { expect change(Advice.unapproved, :count).by(-1) }

      it { expect change(Journal, :count).by(3) }

      it { expect change(Award, :count).by(1) }

      it 'show in news' do
        visit journals_path(project)
        expect(page).to have_content @advice_unapproved.content
      end

      it 'show in personal notification' do
        sign_out
        sign_in user
        visit discontent_post_path(project, @discontent1)
        within :css, 'span.count' do
          expect(page).to have_content '1'
        end
        click_link 'messages'
        within :css, 'ul#messages-menu' do
          expect(page).to have_content @advice_unapproved.content
        end
      end
    end

    it 'delete any advice', js: true do
      expect {
        click_link "remove_advice_#{@advice_unapproved.id}"
        page.driver.browser.accept_js_confirms
        expect(page).not_to have_content @advice_unapproved.content
      }.to change(Advice.unapproved, :count).by(-1)
    end

    context 'discuss with author advice', js: true do
      let(:text_comment) { text_comment = 'Хороший совет, но нужно обсудить' }

      before do
        fill_in "comment_text_for_#{@advice_unapproved.id}", with: text_comment
        click_button "send_comment_for_#{@advice_unapproved.id}"
        visit advices_path(project)
      end

      it { expect change(AdviceComment, :count).by(1) }

      it { expect(page).to have_content text_comment }

      it { expect change(Journal, :count).by(1) }

      it 'show in author advice notifications' do
        sign_out
        sign_in user
        visit discontent_post_path(project, @discontent1)
        within :css, 'span.count' do
          expect(page).to have_content '1'
        end
        click_link 'messages'
        within :css, 'ul#messages-menu' do
          expect(page).to have_content @advice_unapproved.content
        end
      end
    end

    context 'correct link to advisable' do
      it 'to discontent' do
        advice = create :advice_approved, user: user, adviseable: @discontent1
        visit discontent_post_path(project, @discontent1)
        within :css, "#post_advice_#{advice.id}" do
          expect(page).to have_content advice.adviseable.content
          click_link "open_post_#{advice.adviseable.id}"
        end
        expect(current_path) == discontent_post_path(project, advice.adviseable)
      end

      it 'to concept' do
        advice = create :advice_approved, user: user, adviseable: @concept1
        visit concept_post_path(project, @concept1)
        within :css, "#post_advice_#{advice.id}" do
          expect(page).to have_content advice.adviseable.content
        end
        click_link "open_post_#{advice.adviseable.id}"
        expect(current_path) == concept_post_path(project, advice.adviseable)
      end
    end
  end
end
