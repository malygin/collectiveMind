require 'spec_helper'

describe 'Users ' do
  subject { page }
  let (:user) { create :user }
  let (:moderator) { create :moderator }
  let (:project) { create :core_project, status: 1, advices_concept: true, advices_discontent: true }
  let!(:project_user) { create :core_project_user, user: user, core_project: project }
  let!(:project_user2) { create :core_project_user, user: moderator, core_project: project }

  context 'ordinary user sign in ' do
    before do
      sign_in user
    end

    context 'edit profile' do
      it 'owner - ok' do
        new_name = 'Cool new name'
        new_surname = 'My cool surname'
        click_link 'user_profile'
        click_link 'edit_profile'
        fill_in 'user_name', with: new_name
        fill_in 'user_surname', with: new_surname
        click_button 'update_profile'
        expect(current_path).to eq user_path(project.id, user.id)
        expect(page).to have_content new_name
        expect(page).to have_content new_surname
      end

      context 'other user' do
        it 'not show link' do
          visit user_path(project, moderator)
          expect(page).not_to have_link 'edit_profile'
        end

        it 'not access by direct link' do
          visit edit_user_path(project, moderator)
          expect(current_path).to eq root_path
        end
      end
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
end
