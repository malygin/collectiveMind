require 'spec_helper'

describe 'Core Project ' do
  subject { page }

  let (:user) { create :user }
  let (:prime_admin) { create :prime_admin }
  let (:moderator) { create :moderator }
  let (:expert) { create :expert }
  let (:jury) { create :jury }
  let (:club_user) { create :club_user }
  let (:club_watcher) { create :club_watcher }
  let (:ordinary_user) { create :ordinary_user }

  let! (:user_for_closed_project) { create :user }
  let! (:user_for_club_project) { create :club_user }

  let (:project) { create :core_project }
  let (:closed_project_for_invite) { create :core_project, type_access: 2 }
  let! (:opened_project) { create :core_project, type_access: 0 }
  let! (:club_project) { create :core_project, type_access: 1 }
  let! (:closed_project) { create :core_project, type_access: 2 }
  let! (:demo_project) { create :core_project, type_access: 3 }
  let! (:test_project) { create :core_project, type_access: 4 }

  shared_examples 'not_have_content_for_not_auth_user' do
    it '' do
      click_link 'sign_out'
      expect(page).not_to have_link('list_projects', text: 'Список процедур', href: list_projects_path)
      expect(page).not_to have_content 'Закрытые процедуры'
      expect(page).not_to have_content 'Клубные процедуры'
      expect(page).not_to have_content closed_project.name
      expect(page).not_to have_content club_project.name
      expect(page).not_to have_content 'Открытые процедуры'
      expect(page).not_to have_content 'Демо процедуры'
      expect(page).not_to have_content opened_project.name
      expect(page).not_to have_content demo_project.name
      validate_projects_links({closed: closed_project, opened: opened_project, demo: demo_project, club: club_project}, expect: false)
    end
  end

  shared_examples 'not_have_content_for_ordinary_user' do
    it '' do
      expect(page).not_to have_link('list_projects', text: 'Список процедур', href: list_projects_path)
      expect(page).not_to have_content 'Закрытые процедуры'
      expect(page).not_to have_content 'Клубные процедуры'
      expect(page).not_to have_content closed_project.name
      expect(page).not_to have_content club_project.name
      validate_projects_links({closed: closed_project, club: club_project}, expect: false)
    end
  end

  shared_examples 'have_content_for_ordinary_user' do
    it '' do
      expect(page).to have_content 'Открытые процедуры'
      expect(page).to have_content 'Демо процедуры'
      expect(page).to have_content opened_project.name
      expect(page).to have_content demo_project.name
      validate_projects_links({opened: opened_project, demo: demo_project}, expect: true)
    end
  end

  shared_examples 'not_have_content_for_club_user' do
    it '' do
      expect(page).not_to have_link('list_projects', text: 'Список процедур', href: list_projects_path)
      expect(page).not_to have_content 'Закрытые процедуры'
      expect(page).not_to have_content closed_project.name
      validate_projects_links({closed: closed_project}, expect: false)
    end
  end

  shared_examples 'have_content_for_club_user' do
    it '' do
      expect(page).to have_content 'Открытые процедуры'
      expect(page).to have_content 'Демо процедуры'
      expect(page).to have_content 'Клубные процедуры'
      expect(page).to have_content opened_project.name
      expect(page).to have_content demo_project.name
      expect(page).to have_content club_project.name
      validate_projects_links({opened: opened_project, demo: demo_project, club: club_project}, expect: true)
    end
  end

  shared_examples 'not_have_content_for_moderator' do
    it '' do
      expect(page).not_to have_link('list_projects', text: 'Список процедур', href: list_projects_path)
      expect(page).not_to have_content 'Закрытые процедуры'
      expect(page).not_to have_content closed_project.name
      validate_projects_links({closed: closed_project}, expect: false)
    end
  end

  shared_examples 'have_content_for_moderator' do
    it '' do
      expect(page).to have_content 'Открытые процедуры'
      expect(page).to have_content 'Демо процедуры'
      expect(page).to have_content 'Клубные процедуры'
      expect(page).to have_content opened_project.name
      expect(page).to have_content demo_project.name
      expect(page).to have_content club_project.name
      validate_projects_links({opened: opened_project, demo: demo_project, club: club_project}, expect: true)
    end
  end

  context 'ordinary user sign in ' do
    before do
      sign_in user
      visit root_path
    end

    it_behaves_like 'not_have_content_for_not_auth_user'

    it_behaves_like 'not_have_content_for_ordinary_user'

    it_behaves_like 'have_content_for_ordinary_user'

    it 'have base link ' do
      expect(page).to have_link('user_profile', text: user.to_s, href: user_path(user.current_projects_for_user.last, user))
      expect(page).to have_link('sign_out', text: I18n.t('menu.sign_out'), href: destroy_user_session_path)
    end

    it 'have content in profile ' do
      click_link 'user_profile'
      expect(page).to have_content 'Профиль'
      expect(page).to have_content 'Достижения'
      expect(page).to have_content 'Активность'
    end

    it 'success sign out ', js: true do
      click_link 'sign_out'
      expect(page).to have_link('sign_in', text: I18n.t('menu.sign_in'), href: new_user_session_path)
      expect(page).to have_link('sign_up', text: I18n.t('menu.sign_up'), href: new_user_registration_path)
      expect(page).to have_content 'О проекте'
    end

    context 'not have content ' do
      context 'success redirect to root path ' do
        it 'for show closed project ' do
          visit core_project_path(closed_project)
          expect(page.current_path).to eq root_path
        end

        it 'for closed project ' do
          visit "/project/#{closed_project.id}"
          expect(page.current_path).to eq root_path
        end

        it 'for club project ' do
          visit "/project/#{club_project.id}"
          expect(page.current_path).to eq root_path
        end

        it 'for list projects ' do
          visit list_projects_path
          expect(page.current_path).to eq root_path
          expect(page).not_to have_content 'Список процедур'
          expect(page).not_to have_link('new_project', text: 'Создать проект', href: new_core_project_path)
        end

        it 'for new project ' do
          visit new_core_project_path
          expect(page.current_path).to eq root_path
          expect(page).not_to have_selector 'form#new_core_project'
          expect(page).not_to have_content 'Форма создания новой процедуры'
        end

        it 'for edit project ' do
          visit edit_core_project_path(closed_project)
          expect(page.current_path).to eq root_path
          expect(page).not_to have_selector "form#edit_core_project_#{closed_project.id}"
          expect(page).not_to have_content 'Форма редактирования процедуры'
        end

        it 'for list users' do
          visit list_users_users_path(closed_project)
          expect(page.current_path).to eq root_path
          expect(page).not_to have_content 'Выберите участников для закрытой процедуры'
        end

        it 'for next_stage' do
          expect {
            visit next_stage_core_project_path(closed_project)
            expect(page.current_path).to eq root_path
          }.to change { closed_project.status }.by(0)
        end

        it 'for pr_stage' do
          expect {
            visit pr_stage_core_project_path(closed_project)
            expect(page.current_path).to eq root_path
          }.to change { closed_project.status }.by(0)
        end

        it 'for create project' do
          expect {
            page.driver.submit :post, "/core/projects", {}
            expect(page.current_path).to eq root_path
          }.to change(Core::Project, :count).by(0)
        end

        it 'for update project' do
          expect {
            page.driver.submit :put, "/core/projects/#{closed_project.id}", {core_project: {status: 0}}
            expect(page.current_path).to eq root_path
          }.to change { closed_project.status }.by(0)
        end

        it 'for destroy project' do
          expect {
            page.driver.submit :delete, "/core/projects/#{closed_project.id}", {}
            expect(page.current_path).to eq root_path
          }.to change { closed_project.type_access }.by(0)
        end
      end
    end

    context 'have content ' do
      it 'closed project for invited user ' do
        create_invite_for_user(closed_project_for_invite, user)
        visit root_path
        expect(page).to have_content 'Закрытые процедуры'
        expect(page).to have_content 'Открытые процедуры'
        expect(page).to have_content 'Демо процедуры'
        expect(page).to have_content opened_project.name
        expect(page).to have_content demo_project.name
        expect(page).to have_content closed_project_for_invite.name
        validate_projects_links({closed: closed_project_for_invite, opened: opened_project, demo: demo_project}, expect: true)
        expect(page).not_to have_link('list_projects', text: 'Список процедур', href: list_projects_path)
        expect(page).not_to have_content closed_project.name
        expect(page).not_to have_content 'Клубные процедуры'
        expect(page).not_to have_content club_project.name
        validate_projects_links({closed: closed_project, club: club_project}, expect: false)
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
      visit root_path
    end

    it_behaves_like 'not_have_content_for_not_auth_user'

    it_behaves_like 'not_have_content_for_club_user'

    it_behaves_like 'have_content_for_club_user'

    it 'have base link ' do
      expect(page).to have_content club_user.to_s
      expect(page).to have_link('sign_out', text: I18n.t('menu.sign_out'), href: destroy_user_session_path)
    end

    it 'success sign out ', js: true do
      click_link 'sign_out'
      expect(page).to have_link('sign_in', text: I18n.t('menu.sign_in'), href: new_user_session_path)
      expect(page).to have_link('sign_up', text: I18n.t('menu.sign_up'), href: new_user_registration_path)
      expect(page).to have_content 'О проекте'
    end

    context 'not have content ' do
      context 'success redirect to root path ' do
        it 'for show closed project ' do
          visit core_project_path(closed_project)
          expect(page.current_path).to eq root_path
        end

        it 'for closed project ' do
          visit "/project/#{closed_project.id}"
          expect(page.current_path).to eq root_path
        end

        it 'for list projects ' do
          visit list_projects_path
          expect(page.current_path).to eq root_path
          expect(page).not_to have_content 'Список процедур'
          expect(page).not_to have_link('new_project', text: 'Создать проект', href: new_core_project_path)
        end

        it 'for new project ' do
          visit new_core_project_path
          expect(page.current_path).to eq root_path
          expect(page).not_to have_selector 'form#new_core_project'
          expect(page).not_to have_content 'Форма создания новой процедуры'
        end

        it 'for edit project ' do
          visit edit_core_project_path(closed_project)
          expect(page.current_path).to eq root_path
          expect(page).not_to have_selector "form#edit_core_project_#{closed_project.id}"
          expect(page).not_to have_content 'Форма редактирования процедуры'
        end

        it 'for list users' do
          visit list_users_users_path(closed_project)
          expect(page.current_path).to eq root_path
          expect(page).not_to have_content 'Выберите участников для закрытой процедуры'
        end

        it 'for next_stage' do
          expect {
            visit next_stage_core_project_path(closed_project)
            expect(page.current_path).to eq root_path
          }.to change { closed_project.status }.by(0)
        end

        it 'for pr_stage' do
          expect {
            visit pr_stage_core_project_path(closed_project)
            expect(page.current_path).to eq root_path
          }.to change { closed_project.status }.by(0)
        end

        it 'for create project' do
          expect {
            page.driver.submit :post, "/core/projects", {}
            expect(page.current_path).to eq root_path
          }.to change(Core::Project, :count).by(0)
        end

        it 'for update project' do
          expect {
            page.driver.submit :put, "/core/projects/#{closed_project.id}", {core_project: {status: 0}}
            expect(page.current_path).to eq root_path
          }.to change { closed_project.status }.by(0)
        end

        it 'for destroy project' do
          expect {
            page.driver.submit :delete, "/core/projects/#{closed_project.id}", {}
            expect(page.current_path).to eq root_path
          }.to change { closed_project.type_access }.by(0)
        end
      end
    end

    context 'have content ' do
      it 'closed project for invited club user ' do
        create_invite_for_user(closed_project_for_invite, club_user)
        visit root_path
        expect(page).to have_content 'Закрытые процедуры'
        expect(page).to have_content 'Открытые процедуры'
        expect(page).to have_content 'Демо процедуры'
        expect(page).to have_content 'Клубные процедуры'
        expect(page).to have_content opened_project.name
        expect(page).to have_content demo_project.name
        expect(page).to have_content club_project.name
        expect(page).to have_content closed_project_for_invite.name
        validate_projects_links({closed: closed_project_for_invite, opened: opened_project, demo: demo_project, club: club_project}, expect: true)
        expect(page).not_to have_link('list_projects', text: 'Список процедур', href: list_projects_path)
        expect(page).not_to have_content 'closed project'
        validate_projects_links({closed: closed_project}, expect: false)
      end

      it 'success go to closed project for invited club user ' do
        create_invite_for_user(closed_project_for_invite, club_user)
        visit root_path
        find_link("go_to_closed_project_#{closed_project_for_invite.id}", text: 'Перейти к процедуре', href: "/project/#{closed_project_for_invite.id}").click
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
      visit root_path
    end

    it_behaves_like 'not_have_content_for_not_auth_user'

    it_behaves_like 'not_have_content_for_moderator'

    it_behaves_like 'have_content_for_moderator'

    it 'have base link ' do
      expect(page).to have_link('user_profile', text: moderator.to_s, href: user_path(moderator.current_projects_for_user.last, moderator))
      expect(page).to have_link('sign_out', text: I18n.t('menu.sign_out'), href: destroy_user_session_path)
    end

    it 'have content in profile ' do
      click_link 'user_profile'
      expect(page).to have_content 'Профиль'
      expect(page).to have_content 'Активность'
    end

    it 'success sign out ', js: true do
      click_link 'sign_out'
      expect(page).to have_link('sign_in', text: I18n.t('menu.sign_in'), href: new_user_session_path)
      expect(page).to have_link('sign_up', text: I18n.t('menu.sign_up'), href: new_user_registration_path)
      expect(page).to have_content 'О проекте'
    end

    context 'not have content ' do
      context 'success redirect to root path ' do
        it 'for show closed project ' do
          visit core_project_path(closed_project)
          expect(page.current_path).to eq root_path
        end

        it 'for closed project ' do
          visit "/project/#{closed_project.id}"
          expect(page.current_path).to eq root_path
        end

        it 'for list projects ' do
          visit list_projects_path
          expect(page.current_path).to eq root_path
          expect(page).not_to have_content 'Список процедур'
          expect(page).not_to have_link('new_project', text: 'Создать проект', href: new_core_project_path)
        end

        it 'for new project ' do
          visit new_core_project_path
          expect(page.current_path).to eq root_path
          expect(page).not_to have_selector 'form#new_core_project'
          expect(page).not_to have_content 'Форма создания новой процедуры'
        end

        it 'for edit project ' do
          visit edit_core_project_path(closed_project)
          expect(page.current_path).to eq root_path
          expect(page).not_to have_selector "form#edit_core_project_#{closed_project.id}"
          expect(page).not_to have_content 'Форма редактирования процедуры'
        end

        it 'for list users' do
          visit list_users_users_path(closed_project)
          expect(page.current_path).to eq root_path
          expect(page).not_to have_content 'Выберите участников для закрытой процедуры'
        end

        it 'for next_stage' do
          expect {
            visit next_stage_core_project_path(closed_project)
            expect(page.current_path).to eq root_path
          }.to change { closed_project.status }.by(0)
        end

        it 'for pr_stage' do
          expect {
            visit pr_stage_core_project_path(closed_project)
            expect(page.current_path).to eq root_path
          }.to change { closed_project.status }.by(0)
        end

        it 'for create project' do
          expect {
            page.driver.submit :post, "/core/projects", {}
            expect(page.current_path).to eq root_path
          }.to change(Core::Project, :count).by(0)
        end

        it 'for update project' do
          expect {
            page.driver.submit :put, "/core/projects/#{closed_project.id}", {core_project: {status: 0}}
            expect(page.current_path).to eq root_path
          }.to change { closed_project.status }.by(0)
        end

        it 'for destroy project' do
          expect {
            page.driver.submit :delete, "/core/projects/#{closed_project.id}", {}
            expect(page.current_path).to eq root_path
          }.to change { closed_project.type_access }.by(0)
        end
      end
    end

    context 'have content ' do
      it 'closed project for invited club user ' do
        create_invite_for_user(closed_project_for_invite, moderator)
        visit root_path
        expect(page).to have_content 'Закрытые процедуры'
        expect(page).to have_content 'Открытые процедуры'
        expect(page).to have_content 'Демо процедуры'
        expect(page).to have_content 'Клубные процедуры'
        expect(page).to have_content opened_project.name
        expect(page).to have_content demo_project.name
        expect(page).to have_content club_project.name
        expect(page).to have_content closed_project_for_invite.name
        validate_projects_links({closed: closed_project_for_invite, opened: opened_project, demo: demo_project, club: club_project}, expect: true)
        expect(page).not_to have_link('list_projects', text: 'Список процедур', href: list_projects_path)
        expect(page).not_to have_content closed_project.name
        validate_projects_links({closed: closed_project}, expect: false)
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
      visit root_path
    end

    it_behaves_like 'not_have_content_for_not_auth_user'

    it 'have base link ' do
      expect(page).to have_link('user_profile', text: prime_admin.to_s, href: user_path(prime_admin.current_projects_for_user.last, prime_admin))
      expect(page).to have_link('sign_out', text: I18n.t('menu.sign_out'), href: destroy_user_session_path)
      expect(page).to have_link('list_projects', text: 'Список процедур', href: list_projects_path)
    end

    it 'have content in profile ' do
      click_link 'user_profile'
      expect(page).to have_content 'Профиль'
      expect(page).to have_content 'Активность'
    end

    it 'success sign out ', js: true do
      click_link 'sign_out'
      expect(page).to have_link('sign_in', text: I18n.t('menu.sign_in'), href: new_user_session_path)
      expect(page).to have_link('sign_up', text: I18n.t('menu.sign_up'), href: new_user_registration_path)
      expect(page).to have_content 'О проекте'
    end

    context 'have content ' do
      it 'opened and demo project ' do
        expect(page).to have_link('list_projects', text: 'Список процедур', href: list_projects_path)
        expect(page).to have_content 'Открытые процедуры'
        expect(page).to have_content 'Закрытые процедуры'
        expect(page).to have_content 'Демо процедуры'
        expect(page).to have_content 'Клубные процедуры'
        expect(page).to have_content opened_project.name
        expect(page).to have_content closed_project.name
        expect(page).to have_content demo_project.name
        expect(page).to have_content club_project.name
        validate_projects_links({closed: closed_project, opened: opened_project, demo: demo_project, club: club_project}, expect: true)
      end

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
