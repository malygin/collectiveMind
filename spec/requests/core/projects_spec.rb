require 'spec_helper'

describe 'Core Project ', skip: true do
  subject { page }

  let (:user) { create :user }
  let (:moderator) { create :moderator }
  let (:ordinary_user) { create :ordinary_user }
  let! (:user_for_closed_project) { create :user }
  let (:project) { create :core_project }
  let (:closed_project_for_invite) { create :core_project, type_access: 2 }
  let! (:opened_project) { create :core_project, type_access: 0 }
  let! (:closed_project) { create :core_project, type_access: 2 }


  shared_examples 'not_have_content_for_not_auth_user' do
    it '' do
      click_link 'sign_out'
      expect(page).not_to have_link('list_projects', text: 'Список процедур', href: list_projects_path)
      expect(page).not_to have_content 'Закрытые процедуры'
      expect(page).not_to have_content closed_project.name
      expect(page).not_to have_content club_project.name
      expect(page).not_to have_content 'Открытые процедуры'
      expect(page).not_to have_content opened_project.name
      expect(page).not_to have_content demo_project.name
      validate_projects_links({closed: closed_project, opened: opened_project, demo: demo_project, club: club_project}, expect: false)
    end
  end

  shared_examples 'not_have_content_for_ordinary_user' do
    it '' do
      expect(page).not_to have_link('list_projects', text: 'Список процедур', href: list_projects_path)
      expect(page).not_to have_content 'Закрытые процедуры'
      expect(page).not_to have_content closed_project.name
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
      expect(page).to have_link('sign_out', text: 'Выйти', href: destroy_user_session_path)
    end

    it 'success sign out ', js: true do
      click_link 'sign_out'
      expect(page).to have_link('sign_in', text: 'Войти', href: new_user_session_path)
      expect(page).to have_link('sign_up', text: 'Зарегистрироваться', href: new_user_registration_path)
    end

    context 'not have content ' do
      context 'success redirect to root path ' do
        it 'for closed project ' do
          visit "/project/#{closed_project.id}"
          expect(page.current_path).to eq root_path
        end

        it 'for next_stage' do
          expect {
            page.driver.submit :put, "/project/#{closed_project.id}/next_stage"
            expect(page.current_path).to eq root_path
          }.to change { closed_project.stage }.by(0)
        end

        it 'for pr_stage' do
          expect {
            page.driver.submit :put, "/project/#{closed_project.id}/prev_stage"
            expect(page.current_path).to eq root_path
          }.to change { closed_project.stage }.by(0)
        end
      end
    end

    context 'have content ' do
      it 'closed project for invited user ' do
        create_invite_for_user(closed_project_for_invite, user)
        visit root_path
        expect(page).to have_content opened_project.name
        expect(page).to have_content closed_project_for_invite.name
        validate_projects_links({closed: closed_project_for_invite, opened: opened_project}, expect: true)
        expect(page).not_to have_content closed_project.name
        validate_projects_links({closed: closed_project}, expect: false)
      end

      it 'success go to closed project for invited user ' do
        create_invite_for_user(closed_project_for_invite, user)
        visit root_path
        find_link("go_to_closed_project_#{closed_project_for_invite.id}", text: "Перейти к процедуре", href: "/project/#{closed_project_for_invite.id}/").click
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


  context 'moderator sign in' do
    before do
      sign_in moderator
      visit root_path
    end

    it_behaves_like 'not_have_content_for_not_auth_user'

    it_behaves_like 'not_have_content_for_moderator'

    it_behaves_like 'have_content_for_moderator'

    it 'have base link ' do
      expect(page).to have_link('sign_out', text: 'Выйти', href: destroy_user_session_path)
    end

    it 'success sign out ', js: true do
      click_link 'sign_out'
      expect(page).to have_link('sign_in', text: 'Войти', href: new_user_session_path)
      expect(page).to have_link('sign_up', text: 'Зарегистрироваться', href: new_user_registration_path)
    end

    context 'not have content ' do
      context 'success redirect to root path ' do
        it 'for closed project ' do
          visit "/project/#{closed_project.id}"
          expect(page.current_path).to eq aspect_posts_path(closed_project)
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
      end
    end

    context 'have content ' do
      it 'closed project for invited club user ' do
        create_invite_for_user(closed_project_for_invite, moderator)
        visit root_path
        expect(page).to have_content opened_project.name
        expect(page).to have_content closed_project_for_invite.name
        validate_projects_links({closed: closed_project_for_invite, opened: opened_project}, expect: true)
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
  end
end
