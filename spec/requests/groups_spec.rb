# require 'spec_helper'
#
# describe 'Groups', skip: true do
#   subject { page }
#   let (:user) { create :user }
#   let (:user2) { create :user }
#   let (:moderator) { create :moderator }
#   let (:project) { create :core_project }
#   let! (:group) { create_group project, user }
#
#   before do
#     prepare_concepts(project, user)
#   end
#
#   context 'ordinary user sign in ' do
#     before do
#       sign_in user
#       visit groups_path(project)
#     end
#
#     context 'groups only for current project' do
#       before do
#         other_project = create :core_project
#         @group_not_in_project = create :group, project: other_project
#         visit groups_path(project)
#       end
#
#       it { expect(page).not_to have_content @group_not_in_project.name }
#
#       it { expect(page).to have_content group.name }
#
#       it 'in left side' do
#         within :css, 'div#left_side_list_groups' do
#           expect(page).to have_content group.name
#           expect(page).not_to have_content @group_not_in_project.name
#         end
#       end
#     end
#
#     it 'link to groups on project page' do
#       expect have_css 'a#open_groups_list'
#       click_link 'open_groups_list'
#       expect(current_path) == groups_path(project)
#     end
#
#     it 'links to my groups' do
#       create :group_user, user: user, group: group
#       visit groups_path(project)
#       expect(page).to have_link "ls_open_group_#{group.id}"
#     end
#
#     context 'inside group only if member' do
#       it 'link' do
#         create :group_user, user: user, group: group
#         visit groups_path(project)
#         expect(page).to have_link "open_group_#{group.id}"
#       end
#
#       it 'by url' do
#         visit group_path(project, group)
#         expect(current_path) != group_path(project, group)
#       end
#     end
#
#     context 'become a member', js: true do
#       before do
#         sign_out
#         sign_in user2
#         visit groups_path(project)
#         click_link "become_member_#{group.id}"
#       end
#
#       it { expect change(GroupUser, :count).by(1) }
#
#       it { expect(current_path) == group_path(project, group) }
#
#       it { expect(page).to have_link "ls_open_group_#{group.id}" }
#     end
#
#     context 'leave group' do
#       before do
#         visit group_path(project, group)
#         click_link "leave_group_#{group.id}"
#       end
#
#       it { expect change(GroupUser, :count).by(-1) }
#
#       it { expect(current_path) == groups_path(project) }
#
#       it { expect(page).not_to have_link "open_group_#{group.id}" }
#
#       it { expect(page).to have_link "become_member_#{group.id}" }
#     end
#
#     it 'view link to create group' do
#       expect(page).to have_link 'create_group'
#     end
#
#     context 'create group' do
#       let(:group_name) { 'Cool group name' }
#       let(:group_description) { 'Cool group description' }
#
#       context 'ok' do
#         before do
#           visit new_group_path(project)
#           fill_in 'group_name', with: group_name
#           fill_in 'group_description', with: group_description
#           click_button 'save_group'
#         end
#
#         it { expect change(Group.by_project(project), :count).by(1) }
#
#         it { expect(current_path) == groups_path(project) }
#
#         it { expect(page).to have_content group_name }
#
#         it { expect(page).to have_content group_description }
#       end
#
#       context 'empty name' do
#         before do
#           visit new_group_path(project)
#           click_button 'save_group'
#         end
#
#         it { expect change(Group.by_project(project), :count).by(0) }
#
#         it { expect(current_path) == groups_path(project) }
#
#         it { expect(page).to have_css 'div.error_explanation' }
#       end
#     end
#
#     context 'edit' do
#       context 'ok' do
#         let (:new_name) { 'New cool name for group' }
#         before do
#           click_link "edit_group_#{group.id}"
#           fill_in 'group_name', with: new_name
#           click_button 'save_group'
#         end
#
#         it { expect(current_path) == groups_path(project) }
#
#         it { expect(page).to have_content new_name }
#       end
#
#       context 'fill empty name' do
#         before do
#           click_link "edit_group_#{group.id}"
#           fill_in 'group_name', with: ''
#           click_button 'save_group'
#         end
#
#         it { expect(current_path) == groups_path(project) }
#
#         it { expect(page).to have_css 'div.error_explanation' }
#       end
#     end
#
#     it 'destroy', js: true do
#       expect {
#         click_link "remove_group_#{group.id}"
#         page.driver.browser.accept_js_confirms
#         expect(current_path) == groups_path(project)
#       }.to change(Group.by_project(project), :count).by(-1)
#     end
#
#     context 'show page', js: true do
#       before do
#         create :group_user, group: group, user: moderator, invite_accepted: true
#         project.type_access = 2
#         project.save
#         create :core_project_user, core_project: project, user: user2
#         visit group_path(project, group)
#       end
#
#       it 'call moderator' do
#         expect {
#           click_link "call_moderator_for_#{group.id}"
#           expect(page).to have_content I18n.t('groups.call_moderator_success')
#         }.to change(Journal, :count).by(1)
#       end
#
#       context 'send invite' do
#         before do
#           click_button 'button_invite_user'
#           click_link "invite_user_#{user2.id}"
#         end
#
#         it 'no info about invited user' do
#           within :css, 'div#inviteUser' do
#             expect(page).not_to have_content user.to_s
#           end
#         end
#
#         it { expect change(Journal, :count).by(1) }
#
#         context 'as second user' do
#           before do
#             find('#inviteUser button.close').click
#             sign_out
#             sign_in user2
#             visit group_path(project, group)
#           end
#
#           it 'take' do
#             expect {
#               click_link 'take_invite'
#               expect(current_path) == group_path(project, group)
#             }.to change(GroupUser.where(invite_accepted: true), :count).by(1)
#           end
#
#           it 'reject' do
#             expect {
#               click_link 'reject_invite'
#               expect(current_path) == group_path(project, group)
#             }.to change(GroupUser, :count).by(-1)
#           end
#         end
#       end
#
#       it 'list members' do
#         within :css, "ul#users_in_group_#{group.id}" do
#           [user, moderator].each do |user|
#             expect(page).to have_content user.to_s
#           end
#         end
#       end
#     end
#
#     context 'tasks', js: true do
#       let!(:group_task) { create :group_task, group: group }
#
#       before do
#         visit group_path(project, group)
#       end
#
#       it 'not member - not view' do
#         sign_out
#         sign_in user2
#         visit group_path(project, group)
#         expect(page).not_to have_css '#count_of_tasks'
#         expect(page).not_to have_css '#button_create_task'
#         expect(page).not_to have_css '#createTask'
#       end
#
#       context 'create' do
#         before do
#           click_button 'button_create_task'
#         end
#
#         context 'correct' do
#           let(:name_for_task) { 'Cool task' }
#           let(:description_for_task) { 'Cool task' }
#
#           before do
#             fill_in 'group_task_name', with: name_for_task
#             fill_in 'group_task_description', with: description_for_task
#             click_button 'save_task'
#           end
#
#           it { expect change(group.tasks, :count).by(1) }
#
#           it 'show content' do
#             within :css, "#group_tasks_#{group.id}" do
#               expect(page).to have_content name_for_task
#               expect(page).to have_content description_for_task
#             end
#           end
#
#           it 'count tasks' do
#             within :css, '#count_of_tasks' do
#               expect(page).to have_content group.tasks.count
#             end
#           end
#         end
#
#         context 'with empty fields' do
#           before do
#             click_button 'save_task'
#           end
#
#           it { expect change(group.tasks, :count).by(0) }
#
#           it 'message about error' do
#             within :css, '#createTask' do
#               expect(page).to have_css 'div.error_explanation'
#             end
#           end
#         end
#       end
#
#       it 'edit' do
#         new_name = 'New cool name'
#         new_description = 'New cool description'
#         expect {
#           click_button "edit_task_#{group_task.id}"
#           within :css, '#editTask' do
#             fill_in 'group_task_name', with: new_name
#             fill_in 'group_task_description', with: new_description
#             click_button 'save_task'
#           end
#           expect(page).to have_content new_name
#           expect(page).to have_content new_description
#         }.not_to change(group.tasks, :count)
#       end
#
#       it 'destroy' do
#         expect {
#           click_link "remove_task_#{group_task.id}"
#           page.driver.browser.accept_js_confirms
#           sleep 2
#           expect(page).not_to have_content group_task.name
#           expect(page).not_to have_content group_task.description
#         }.to change(group.tasks, :count).by(-1)
#       end
#
#       context 'assign to' do
#         let!(:task_for_assign) { create :group_task, group: group }
#         before do
#           visit group_path(project, group)
#           click_button "assign_user_to_#{task_for_assign.id}"
#           within :css, "#assignTaskToUser#{task_for_assign.id}" do
#             click_link "assign_user_#{user.id}_to_"
#           end
#         end
#
#         it { expect change(task_for_assign.group_task_users, :count).by(1) }
#
#         it { expect change(group_task.group_task_users, :count).by(0) }
#
#         it { expect change(Journal, :count).by(1) }
#
#         it 'not show user in list to assign' do
#           sleep 5
#           within :css, "#assignTaskToUser#{task_for_assign.id}" do
#             expect(page).not_to have_content user.to_s
#           end
#         end
#
#         #@todo разобраться почему здесь Capybara::Webkit::InvalidResponseError: SyntaxError: DOM Exception 12
#         #тест не сильно критичный, поэтому пока xit
#         xit 'show user in list' do
#           sleep 5
#           puts "#assignTaskToUser#{task_for_assign.id} button.close"
#           find("#assignTaskToUser#{task_for_assign.id} button.close").click
#           within :css, "##{task_for_assign.id}_task_users" do
#             expect(page).to have_content user.to_s
#           end
#         end
#       end
#     end
#
#     context 'chat', js: true do
#       before do
#         visit group_path(project, group)
#       end
#
#       it 'attach file' do
#         expect {
#           attach_file('file', "#{Rails.root}/spec/support/images/1.jpg")
#           sleep(5)
#           m = /[A-z0-9]*.jpg/.match GroupChatMessage.last.content
#           file_name = m[0][0..m[0].length - 5]
#           Cloudinary::Api.delete_resources("#{GroupChatMessage::GROUP_FOLDER}/#{file_name}")
#         }.to change(GroupChatMessage, :count).by(1)
#       end
#     end
#
#     it 'users projects' do
#       plan = create :plan, user: user, project: project
#       project.status = 9
#       project.save
#       visit group_path(project, group)
#       expect(page).to have_content plan.name
#       click_link "open_user_project_#{plan.id}"
#       expect(current_path) == plan_post_path(project, plan)
#     end
#   end
# end
