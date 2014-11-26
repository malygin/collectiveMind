require 'spec_helper'

describe 'Groups' do
  subject { page }
  let (:user) { create :user }
  let (:user2) { create :user }
  let (:moderator) { create :moderator }
  let (:project) { create :core_project }
  let! (:group) { create_group project, user }

  before do
    prepare_concepts(project, user)
  end

  context 'ordinary user sign in ' do
    before do
      sign_in user
      visit groups_path(project)
    end

    context 'groups only for current project' do
      before do
        other_project = create :core_project
        @group_not_in_project = create :group, project: other_project
        visit groups_path(project)
      end

      it { expect(page).not_to have_content @group_not_in_project.name }

      it { expect(page).to have_content group.name }
    end

    it 'link to groups on project page' do
      expect have_css 'a#open_groups_list'
      click_link 'open_groups_list'
      expect(current_path) == groups_path(project)
    end

    it 'links to my groups' do
      create :group_user, user: user, group: group
      visit groups_path(project)
      expect(page).to have_link "ls_open_group_#{group.id}"
    end

    context 'inside group only if member' do
      it 'link' do
        create :group_user, user: user, group: group
        visit groups_path(project)
        expect(page).to have_link "open_group_#{group.id}"
      end

      it 'by url' do
        visit group_path(project, group)
        expect(current_path) != group_path(project, group)
      end
    end

    context 'become a member', js: true do
      before do
        sign_out
        sign_in user2
        visit groups_path(project)
        click_link "become_member_#{group.id}"
      end

      it { expect change(GroupUser, :count).by(1) }

      it { expect(current_path) == group_path(project, group) }

      it { expect(page).to have_link "ls_open_group_#{group.id}" }
    end

    context 'leave group' do
      before do
        visit group_path(project, group)
        click_link "leave_group_#{group.id}"
      end

      it { expect change(GroupUser, :count).by(-1) }

      it { expect(current_path) == groups_path(project) }

      it { expect(page).not_to have_link "open_group_#{group.id}" }

      it { expect(page).to have_link "become_member_#{group.id}" }
    end

    it 'view link to create group' do
      expect(page).to have_link 'create_group'
    end

    context 'create group' do
      let(:group_name) { 'Cool group name' }
      let(:group_description) { 'Cool group description' }

      context 'ok' do
        before do
          visit new_group_path(project)
          fill_in 'group_name', with: group_name
          fill_in 'group_description', with: group_description
          click_button 'save_group'
        end

        it { expect change(Group.by_project(project), :count).by(1) }

        it { expect(current_path) == groups_path(project) }

        it { expect(page).to have_content group_name }

        it { expect(page).to have_content group_description }
      end

      context 'empty name' do
        before do
          visit new_group_path(project)
          click_button 'save_group'
        end

        it { expect change(Group.by_project(project), :count).by(0) }

        it { expect(current_path) == groups_path(project) }

        it { expect(page).to have_css 'div.error_explanation' }
      end
    end

    context 'edit' do
      context 'ok' do
        let (:new_name) { 'New cool name for group' }
        before do
          click_link "edit_group_#{group.id}"
          fill_in 'group_name', with: new_name
          click_button 'save_group'
        end

        it { expect(current_path) == groups_path(project) }

        it { expect(page).to have_content new_name }
      end

      context 'fill empty name' do
        before do
          click_link "edit_group_#{group.id}"
          fill_in 'group_name', with: ''
          click_button 'save_group'
        end

        it { expect(current_path) == groups_path(project) }

        it { expect(page).to have_css 'div.error_explanation' }
      end
    end

    it 'destroy', js: true do
      expect {
        click_link "remove_group_#{group.id}"
        page.driver.browser.accept_js_confirms
        expect(current_path) == groups_path(project)
      }.to change(Group.by_project(project), :count).by(-1)
    end

    context 'show page', js: true do
      before do
        create :group_user, group: group, user: moderator, invite_accepted: true
        create :core_project_user, core_project: project, user: user2
        visit group_path(project, group)
      end

      it 'link to project' do
        click_link "go_to_project_#{project.id}"
        expect(current_path) == "/project/#{project.id}/life_tape/posts"
      end

      it 'call moderator' do
        expect {
          click_link "call_moderator_for_#{group.id}"
          expect(page).to have_content I18n.t('groups.call_moderator_success')
        }.to change(Journal, :count).by(1)
      end

      context 'send invite' do
        before do
          click_button 'button_invite_user'
          click_link "invite_user_#{user2.id}"
        end

        it 'no info about invited user' do
          within :css, 'div#inviteUser' do
            expect(page).not_to have_content user.to_s
          end
        end

        it { expect change(Journal, :count).by(1) }

        context 'as second user' do
          before do
            find('#inviteUser button.close').click
            sign_out
            sign_in user2
            visit group_path(project, group)
          end

          it 'take' do
            expect {
              click_link 'take_invite'
              expect(current_path) == group_path(project, group)
            }.to change(GroupUser.where(invite_accepted: true), :count).by(1)
          end

          it 'reject' do
            expect {
              click_link 'reject_invite'
              expect(current_path) == group_path(project, group)
            }.to change(GroupUser, :count).by(-1)
          end
        end
      end

      it 'list members' do
        within :css, "div#users_in_group_#{group.id}" do
          [user, moderator].each do |user|
            expect(page).to have_content user.to_s
          end
        end
      end
    end

    context 'tasks' do
      context 'create'
      context 'assign to'
      context 'edit'
      context 'destroy'
      context 'list'
    end

    context 'chat'
  end
end
