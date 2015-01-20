require 'spec_helper'

describe 'Users ' do
  subject { page }
  let (:user) { create :user }
  let (:project) { create :core_project, advices_concept: true, advices_discontent: true }

  context 'ordinary user sign in ' do
    before do
      sign_in user
    end

    context 'base links' do
      it { expect(page).to have_link('user_profile', text: user.to_s, href: user_path(user.current_projects_for_user.last, user)) }

      it { expect(page).to have_link('sign_out', text: 'Выйти', href: destroy_user_session_path) }
    end

    it 'have content in profile ' do
      click_link 'user_profile'
      expect(page).to have_content 'Профиль'
      expect(page).to have_content 'Достижения'
      expect(page).to have_content 'Активность'
    end

    it 'success sign out ', js: true do
      click_link 'sign_out'
      expect(page).to have_link('sign_in', text: 'Войти', href: new_user_session_path)
      expect(page).to have_link('sign_up', text: 'Зарегистрироваться', href: new_user_registration_path)
      expect(page).to have_content 'О проекте'
    end

    context 'my journal', js: true do
      before do
        @personal_journal = create :personal_journal, project: project, user: user, user_informed: user
        visit "/project/#{project.id}"
      end

      it 'have count' do
        within :css, 'a#messages span.count' do
          expect(page).to have_content '1'
        end
      end

      it 'have content on click' do
        click_link 'messages'
        within :css, 'ul#messages-menu' do
          expect(page).to have_content @personal_journal.body
        end
      end

      context 'clear' do
        before do
          click_link 'messages'
          click_link 'clear_my_journals'
        end

        it { expect change(Journal.events_for_my_feed(project, user), :count).by(-1) }

        it 'on page' do
          expect(page).not_to have_content @personal_journal
          expect(page).not_to have_link 'clear_my_journals'
          expect(page).to have_content I18n.t('menu.journal_empty')
        end
      end
    end

    context 'unreaded notifications: show message', js: true do
      context 'when' do
        it '1 day - yes' do
          @personal_journal = create :personal_journal, project: project, user: user, user_informed: user, created_at: 1.day.ago
          visit "/project/#{project.id}"
          expect(page).to have_css '#set_notification_message'
          expect(page).not_to have_content @personal_journal.body
          find('div.messenger-actions a').click
          expect(page).to have_content @personal_journal.body
        end

        it ' < 1 day - no' do
          @personal_journal = create :personal_journal, project: project, user: user, user_informed: user
          visit "/project/#{project.id}"
          expect(page).not_to have_css 'div#set_notification_message'
          expect(page).not_to have_css 'div.messenger-message-inner'
        end
      end
    end
  end

  context 'moderator sign in ' do

  end

  context 'expert sign in ' do

  end
end
