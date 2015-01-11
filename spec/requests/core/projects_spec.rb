require 'spec_helper'

describe 'Core Project ' do
  subject { page }

  let (:user) { create :user }
  let (:prime_admin) { create :prime_admin }
  let (:moderator) { create :moderator }
  let (:club_user) { create :club_user }
  let (:club_watcher) { create :club_watcher }
  let (:ordinary_user) { create :ordinary_user }
  let! (:user_for_closed_project) { create :user }
  let! (:user_for_club_project) { create :club_user }
  let (:project) { create :core_project }
  let (:closed_project_for_invite) { create :core_project, type_access: 2, name: 'closed invited project' }
  let! (:opened_project) { create :core_project, name: 'opened project' }
  let! (:club_project) { create :club_project, name: 'club project' }
  let! (:closed_project) { create :closed_project, name: 'closed project' }

  shared_examples 'not_have_content_for_ordinary_user' do
    it '' do
      expect(page).not_to have_link('list_projects', text: 'Список процедур', href: list_projects_path)
      expect(page).not_to have_content 'Закрытые процедуры'
      expect(page).not_to have_content 'Клубные процедуры'
      expect(page).not_to have_content 'closed project'
      expect(page).not_to have_content 'club project'
      validate_projects_links({closed: closed_project, club: club_project}, expect: false)
    end
  end

  shared_examples 'not_have_content_for_club_user' do
    it '' do
      expect(page).not_to have_link('list_projects', text: 'Список процедур', href: list_projects_path)
      expect(page).not_to have_content 'Закрытые процедуры'
      expect(page).not_to have_content 'closed project'
      validate_projects_links({closed: closed_project}, expect: false)
    end
  end

  context 'ordinary user sign in ' do
    before do
      sign_in user
    end

    context 'not have content ' do
      describe 'closed and club project ' do
        it_behaves_like 'not_have_content_for_ordinary_user'
      end

      context 'success redirect to root path ' do
        describe 'for show closed project ' do
          before do
            visit core_project_path(closed_project)
            expect(page.current_path).to eq root_path
          end

          it_behaves_like 'not_have_content_for_ordinary_user'
        end

        describe 'for closed project ' do
          before do
            visit "/project/#{closed_project.id}"
            expect(page.current_path).to eq root_path
          end

          it_behaves_like 'not_have_content_for_ordinary_user'
        end

        describe 'for club project ' do
          before do
            visit "/project/#{club_project.id}"
            expect(page.current_path).to eq root_path
          end

          it_behaves_like 'not_have_content_for_ordinary_user'
        end

        describe 'for list projects ' do
          before do
            visit list_projects_path
            expect(page.current_path).to eq root_path
            expect(page).not_to have_content 'Список процедур'
            expect(page).not_to have_link('new_project', text: 'Создать проект', href: new_core_project_path)
          end

          it_behaves_like 'not_have_content_for_ordinary_user'
        end

        describe 'for new project ' do
          before do
            visit new_core_project_path
            expect(page.current_path).to eq root_path
            expect(page).not_to have_selector 'form#new_core_project'
            expect(page).not_to have_content 'Форма создания новой процедуры'
          end

          it_behaves_like 'not_have_content_for_ordinary_user'
        end

        describe 'for edit project ' do
          before do
            visit edit_core_project_path(closed_project)
            expect(page.current_path).to eq root_path
            expect(page).not_to have_selector "form#edit_core_project_#{closed_project.id}"
            expect(page).not_to have_content 'Форма редактирования процедуры'
          end

          it_behaves_like 'not_have_content_for_ordinary_user'
        end

        describe 'for list users' do
          before do
            visit list_users_users_path(closed_project)
            expect(page.current_path).to eq root_path
            expect(page).not_to have_content 'Выберите участников для закрытой процедуры'
          end

          it_behaves_like 'not_have_content_for_ordinary_user'
        end

        describe 'for next_stage' do
          before do
            expect {
              visit next_stage_core_project_path(closed_project)
              expect(page.current_path).to eq root_path
            }.to change { closed_project.status }.by(0)
          end

          it_behaves_like 'not_have_content_for_ordinary_user'
        end

        describe 'for pr_stage' do
          before do
            expect {
              visit pr_stage_core_project_path(closed_project)
              expect(page.current_path).to eq root_path
            }.to change { closed_project.status }.by(0)
          end

          it_behaves_like 'not_have_content_for_ordinary_user'
        end

        describe 'for create project' do
          before do
            expect {
              page.driver.submit :post, "/core/projects", {}
              expect(page.current_path).to eq root_path
            }.to change(Core::Project, :count).by(0)
          end

          it_behaves_like 'not_have_content_for_ordinary_user'
        end

        describe 'for update project' do
          before do
            expect {
              page.driver.submit :put, "/core/projects/#{closed_project.id}", {core_project: {status: 0}}
              expect(page.current_path).to eq root_path
            }.to change { closed_project.status }.by(0)
          end

          it_behaves_like 'not_have_content_for_ordinary_user'
        end

        describe 'for destroy project' do
          before do
            expect {
              page.driver.submit :delete, "/core/projects/#{closed_project.id}", {}
              expect(page.current_path).to eq root_path
            }.to change { closed_project.type_access }.by(0)
          end

          it_behaves_like 'not_have_content_for_ordinary_user'
        end
      end
    end

    context 'have content ' do
      describe 'closed project for invited user ' do
        before do
          create_invite_for_user(closed_project_for_invite, user)
          visit root_path
        end

        it '' do
          expect(page).not_to have_link('list_projects', text: 'Список процедур', href: list_projects_path)
          expect(page).not_to have_content 'closed project'
          expect(page).not_to have_content 'Клубные процедуры'
          expect(page).not_to have_content 'club project'
          validate_projects_links({closed: closed_project, club: club_project}, expect: false)
        end
      end

      it 'success go to closed project for invited user ' do
        create_invite_for_user(closed_project_for_invite, user)
        visit root_path
        find_link("go_to_closed_project_#{closed_project_for_invite.id}", text: "Перейти к процедуре", href: "/project/#{closed_project_for_invite.id}").click
        validate_default_links_and_sidebar(closed_project_for_invite, user)
        validate_not_have_admin_links_for_user(project)
        validate_not_have_moderator_links_for_user(project)
        validation_visit_links_for_user(closed_project_for_invite, user)
        validation_visit_not_have_links_for_user(project, user)
      end

      it 'success refirect if closed stage ' do
        create_invite_for_user(closed_project_for_invite, user)
        visit root_path
        find_link("go_to_closed_project_#{closed_project_for_invite.id}", text: "Перейти к процедуре", href: "/project/#{closed_project_for_invite.id}").click
        visit discontent_posts_path(closed_project_for_invite)
        expect(page.current_path).to eq life_tape_posts_path(closed_project_for_invite)
      end
    end
  end

  context 'club user sign in' do
    before do
      sign_in club_user
    end

    context 'not have content ' do
      it_behaves_like 'not_have_content_for_club_user'

      context 'success redirect to root path ' do
        describe 'for show closed project ' do
          before do
            visit core_project_path(closed_project)
            expect(page.current_path).to eq root_path
          end

          it_behaves_like 'not_have_content_for_club_user'
        end

        describe 'for closed project ' do
          before do
            visit "/project/#{closed_project.id}"
            expect(page.current_path).to eq root_path
          end

          it_behaves_like 'not_have_content_for_club_user'
        end

        describe 'for list projects ' do
          before do
            visit list_projects_path
            expect(page.current_path).to eq root_path
            expect(page).not_to have_content 'Список процедур'
            expect(page).not_to have_link('new_project', text: 'Создать проект', href: new_core_project_path)
          end

          it_behaves_like 'not_have_content_for_club_user'
        end

        describe 'for new project ' do
          before do
            visit new_core_project_path
            expect(page.current_path).to eq root_path
            expect(page).not_to have_selector 'form#new_core_project'
            expect(page).not_to have_content 'Форма создания новой процедуры'
          end

          it_behaves_like 'not_have_content_for_club_user'
        end

        describe 'for edit project ' do
          before do
            visit edit_core_project_path(closed_project)
            expect(page.current_path).to eq root_path
            expect(page).not_to have_selector "form#edit_core_project_#{closed_project.id}"
            expect(page).not_to have_content 'Форма редактирования процедуры'
          end

          it_behaves_like 'not_have_content_for_club_user'
        end

        describe 'for list users' do
          before do
            visit list_users_users_path(closed_project)
            expect(page.current_path).to eq root_path
            expect(page).not_to have_content 'Выберите участников для закрытой процедуры'
          end

          it_behaves_like 'not_have_content_for_club_user'
        end

        describe 'for next_stage' do
          before do
            expect {
              visit next_stage_core_project_path(closed_project)
              expect(page.current_path).to eq root_path
            }.to change { closed_project.status }.by(0)
          end

          it_behaves_like 'not_have_content_for_club_user'
        end

        describe 'for pr_stage' do
          before do
            expect {
              visit pr_stage_core_project_path(closed_project)
              expect(page.current_path).to eq root_path
            }.to change { closed_project.status }.by(0)
          end

          it_behaves_like 'not_have_content_for_club_user'
        end

        describe 'for create project' do
          before do
            expect {
              page.driver.submit :post, "/core/projects", {}
              expect(page.current_path).to eq root_path
            }.to change(Core::Project, :count).by(0)
          end

          it_behaves_like 'not_have_content_for_club_user'
        end

        describe 'for update project' do
          before do
            expect {
              page.driver.submit :put, "/core/projects/#{closed_project.id}", {core_project: {status: 0}}
              expect(page.current_path).to eq root_path
            }.to change { closed_project.status }.by(0)
          end

          it_behaves_like 'not_have_content_for_club_user'
        end

        describe 'for destroy project' do
          before do
            expect {
              page.driver.submit :delete, "/core/projects/#{closed_project.id}", {}
              expect(page.current_path).to eq root_path
            }.to change { closed_project.type_access }.by(0)
          end

          it_behaves_like 'not_have_content_for_club_user'
        end
      end
    end

    context 'have content ' do
      it 'closed project for invited club user ' do
        create_invite_for_user(closed_project_for_invite, club_user)
        visit root_path
        not_have_content_for_invited_club_user(closed_project)
      end

      it 'success go to closed project for invited club user ' do
        create_invite_for_user(closed_project_for_invite, club_user)
        visit root_path
        find_link("go_to_closed_project_#{closed_project_for_invite.id}", text: "Перейти к процедуре", href: "/project/#{closed_project_for_invite.id}").click
        validate_default_links_and_sidebar(closed_project_for_invite, club_user)
        validate_not_have_admin_links_for_user(project)
        validate_not_have_moderator_links_for_user(project)
        validation_visit_links_for_user(closed_project_for_invite, club_user)
        validation_visit_not_have_links_for_user(project, club_user)
      end

      it 'success refirect if closed stage ' do
        create_invite_for_user(closed_project_for_invite, club_user)
        visit root_path
        find_link("go_to_closed_project_#{closed_project_for_invite.id}", text: "Перейти к процедуре", href: "/project/#{closed_project_for_invite.id}").click
        visit discontent_posts_path(closed_project_for_invite)
        expect(page.current_path).to eq life_tape_posts_path(closed_project_for_invite)
      end
    end
  end

  context 'moderator sign in' do
    before do
      sign_in moderator
    end

    context 'not have content ' do
      it 'closed project ' do
        not_have_content_for_moderator(closed_project)
      end

      context 'success redirect to root path ' do
        it 'for show closed project ' do
          visit core_project_path(closed_project)
          expect(page.current_path).to eq root_path
          not_have_content_for_moderator(closed_project)
        end

        it 'for closed project ' do
          visit "/project/#{closed_project.id}"
          expect(page.current_path).to eq root_path
          not_have_content_for_moderator(closed_project)
        end

        it 'for list projects ' do
          visit list_projects_path
          expect(page.current_path).to eq root_path
          expect(page).not_to have_content 'Список процедур'
          expect(page).not_to have_link('new_project', text: 'Создать проект', href: new_core_project_path)
          not_have_content_for_moderator(closed_project)
        end

        it 'for new project ' do
          visit new_core_project_path
          expect(page.current_path).to eq root_path
          expect(page).not_to have_selector 'form#new_core_project'
          expect(page).not_to have_content 'Форма создания новой процедуры'
          not_have_content_for_moderator(closed_project)
        end

        it 'for edit project ' do
          visit edit_core_project_path(closed_project)
          expect(page.current_path).to eq root_path
          expect(page).not_to have_selector "form#edit_core_project_#{closed_project.id}"
          expect(page).not_to have_content 'Форма редактирования процедуры'
          not_have_content_for_moderator(closed_project)
        end

        it 'for list users' do
          visit list_users_users_path(closed_project)
          expect(page.current_path).to eq root_path
          expect(page).not_to have_content 'Выберите участников для закрытой процедуры'
          not_have_content_for_moderator(closed_project)
        end

        it 'for next_stage' do
          expect {
            visit next_stage_core_project_path(closed_project)
            expect(page.current_path).to eq root_path
            not_have_content_for_moderator(closed_project)
          }.to change { closed_project.status }.by(0)
        end

        it 'for pr_stage' do
          expect {
            visit pr_stage_core_project_path(closed_project)
            expect(page.current_path).to eq root_path
            not_have_content_for_moderator(closed_project)
          }.to change { closed_project.status }.by(0)
        end

        it 'for create project' do
          expect {
            page.driver.submit :post, "/core/projects", {}
            expect(page.current_path).to eq root_path
            not_have_content_for_moderator(closed_project)
          }.to change(Core::Project, :count).by(0)
        end

        it 'for update project' do
          expect {
            page.driver.submit :put, "/core/projects/#{closed_project.id}", {core_project: {status: 0}}
            expect(page.current_path).to eq root_path
            not_have_content_for_moderator(closed_project)
          }.to change { closed_project.status }.by(0)
        end

        it 'for destroy project' do
          expect {
            page.driver.submit :delete, "/core/projects/#{closed_project.id}", {}
            expect(page.current_path).to eq root_path
            not_have_content_for_moderator(closed_project)
          }.to change { closed_project.type_access }.by(0)
        end
      end
    end

    context 'have content ' do
      it 'closed project for invited club user ' do
        create_invite_for_user(closed_project_for_invite, moderator)
        visit root_path
        not_have_content_for_invited_moderator(closed_project)
      end

      it 'success go to closed project for invited club user ' do
        create_invite_for_user(closed_project_for_invite, moderator)
        visit root_path
        find_link("go_to_closed_project_#{closed_project_for_invite.id}", text: "Перейти к процедуре", href: "/project/#{closed_project_for_invite.id}").click
        validate_default_links_and_sidebar(closed_project_for_invite, moderator)
        validate_not_have_admin_links_for_moderator(project)
        validation_visit_links_for_user(closed_project_for_invite, moderator)
        validation_visit_not_have_links_for_moderator(closed_project_for_invite, moderator)
        validation_visit_links_for_moderator(project)
      end

      it 'success refirect if closed stage ' do
        create_invite_for_user(closed_project_for_invite, moderator)
        visit root_path
        find_link("go_to_closed_project_#{closed_project_for_invite.id}", text: "Перейти к процедуре", href: "/project/#{closed_project_for_invite.id}").click
        visit discontent_posts_path(closed_project_for_invite)
        expect(page.current_path).to eq life_tape_posts_path(closed_project_for_invite)
      end
    end
  end


  context 'prime admin sign in' do
    before do
      sign_in prime_admin
    end

    context 'have content ' do
      it 'success go to closed project for prime admin ' do
        find_link("go_to_closed_project_#{closed_project.id}", text: "Перейти к процедуре", href: "/project/#{closed_project.id}").click
        validate_default_links_and_sidebar(closed_project, prime_admin)
        validate_have_prime_admin_links(closed_project)
        validate_have_moderator_links(closed_project)
        validation_visit_links_for_user(closed_project, prime_admin)
        validation_visit_links_for_moderator(closed_project)
      end

      it 'success refirect if closed stage ' do
        find_link("go_to_closed_project_#{closed_project.id}", text: "Перейти к процедуре", href: "/project/#{closed_project.id}").click
        visit discontent_posts_path(closed_project)
        expect(page.current_path).to eq life_tape_posts_path(closed_project)
      end
    end

    context 'links for admin ' do
      context 'success open ' do
        it 'for show closed project ' do
          visit core_project_path(closed_project)
          expect(page.current_path).to eq core_project_path(closed_project)
        end

        it 'for closed project ' do
          visit "/project/#{closed_project.id}"
          expect(page.current_path).to eq life_tape_posts_path(closed_project)
        end

        it 'for list projects ' do
          visit list_projects_path
          expect(page.current_path).to eq list_projects_path
          expect(page).to have_content 'Список процедур'
          expect(page).to have_link('new_project', text: 'Создать проект', href: new_core_project_path)
        end

        it 'for new project ' do
          visit new_core_project_path
          expect(page.current_path).to eq new_core_project_path
          expect(page).to have_selector 'form#new_core_project'
          expect(page).to have_content 'Форма создания новой процедуры'
        end

        it 'for edit project ' do
          visit edit_core_project_path(closed_project)
          expect(page.current_path).to eq edit_core_project_path(closed_project)
          expect(page).to have_selector "form#edit_core_project_#{closed_project.id}"
          expect(page).to have_content 'Форма редактирования процедуры'
        end

        it 'for list users' do
          visit list_users_users_path(closed_project)
          expect(page.current_path).to eq list_users_users_path(closed_project)
          expect(page).to have_content 'Выберите участников для закрытой процедуры'
        end
      end
    end

    context 'new project' do
      before do
        visit new_core_project_path
      end

      it 'success new project' do
        expect(page).to have_content 'Форма создания новой процедуры'
        fill_in 'core_project_name', with: 'new project'
        fill_in 'core_project_short_desc', with: 'new project_short_desc'
        fill_in 'core_project_desc', with: 'new project_desc'
        page.select 'Закрытая', from: 'core_project_type_access'
        click_button 'send_project'
        expect(page).to have_content 'new project'
      end
    end

    context 'edit project' do
      before do
        visit edit_core_project_path(closed_project)
      end

      it 'success edit project' do
        expect(page).to have_content 'Форма редактирования процедуры'
        fill_in 'core_project_name', with: 'edit project'
        fill_in 'core_project_short_desc', with: 'edit project_short_desc'
        fill_in 'core_project_desc', with: 'edit project_desc'
        page.select 'Клубная', from: 'core_project_type_access'
        click_button 'send_project'
        expect(page).to have_content 'edit project'
      end
    end

    context 'list_users_users' do
      before do
        visit list_users_users_path(closed_project)
      end

      it 'success list users for closed projects', js: true do
        expect(page).to have_content 'Выберите участников для закрытой процедуры'
        expect(page).to have_content closed_project.name
        expect(page).to have_content prime_admin.to_s
        expect(page).to have_content user_for_closed_project.to_s
        expect(page).to have_content 'Добавить'
        expect {
          click_link "add_user_#{user_for_closed_project.id}"
          expect(page).to have_selector "a", 'Удалить'
          sleep(1)
        }.to change(Core::ProjectUser, :count).by(1)
      end
    end
  end
end
