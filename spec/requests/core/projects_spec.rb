require 'spec_helper'

describe 'Core Project ' do
  subject { page }

  let (:user) { create :user }
  let (:moderator) { create :moderator }
  let (:project) { create :core_project }
  let (:closed_project_for_invite) { create :core_project, type_access: 2 }
  let! (:opened_project) { create :core_project, type_access: 0 }
  let! (:closed_project) { create :core_project, type_access: 2 }

  shared_examples 'not_have_content_for_not_auth_user' do
    it '' do
      click_link 'sign_out'
      expect(page).not_to have_content closed_project.name
      expect(page).not_to have_content opened_project.name
      validate_projects_links({closed: closed_project, opened: opened_project}, expect: false)
    end
  end

  shared_examples 'not_have_content_for_ordinary_user' do
    it '' do
      expect(page).not_to have_content closed_project.name
      validate_projects_links({closed: closed_project}, expect: false)
    end
  end

  shared_examples 'have_content_for_ordinary_user' do
    it '' do
      expect(page).to have_content opened_project.name
      validate_projects_links({opened: opened_project}, expect: true)
    end
  end

  shared_examples 'have_content_for_moderator' do
    it '' do
      expect(page).to have_content closed_project.name
      expect(page).to have_content opened_project.name
      validate_projects_links({opened: opened_project, closed: closed_project}, expect: true)
    end
  end

  context 'ordinary user sign in ', js: true do
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
      expect(page).to have_link('sign_in', text: 'Войти')
      expect(page).to have_link('sign_up', text: 'Зарегистрироваться')
    end

    context 'success redirect to root path ' do
      before do
        visit "/project/#{closed_project.id}"
      end

      it 'for closed project ' do
        expect(page.current_path).to eq root_path
      end

      it 'for next_stage closed project' do
        expect {
          custom_method_submit(:put, "/project/#{closed_project.id}/next_stage")
          expect(page.current_path).to eq root_path
        }.to_not change { closed_project.reload.stage }
      end

      it 'for pr_stage closed project' do
        expect {
          custom_method_submit(:put, "/project/#{closed_project.id}/prev_stage")
          expect(page.current_path).to eq root_path
        }.to_not change { closed_project.reload.stage }
      end
    end

    context 'success current links for invite ' do
      before do
        create_invite_for_user(closed_project_for_invite, user)
        create_intro_for_user(closed_project_for_invite, user)
        visit "/project/#{closed_project_for_invite.id}"
      end

      it 'for invite project ' do
        expect(page.current_path).to eq aspect_posts_path(closed_project_for_invite)
      end

      it 'for next_stage invite project' do
        expect(page).not_to have_link('open_next_stage', href: "/project/#{closed_project_for_invite.id}/next_stage")
        expect {
          custom_method_submit(:put, "/project/#{closed_project_for_invite.id}/next_stage")
          expect(page.current_path).to eq aspect_posts_path(closed_project_for_invite)
        }.to_not change { closed_project_for_invite.reload.stage }
      end

      it 'for pr_stage invite project' do
        expect(page).not_to have_link('open_prev_stage', href: "/project/#{closed_project_for_invite.id}/prev_stage")
        expect {
          custom_method_submit(:put, "/project/#{closed_project_for_invite.id}/prev_stage")
          expect(page.current_path).to eq aspect_posts_path(closed_project_for_invite)
        }.to_not change { closed_project_for_invite.reload.stage }
      end
    end

    context 'have content ' do
      before do
        create_invite_for_user(closed_project_for_invite, user)
        create_intro_for_user(closed_project_for_invite, user)
        visit root_path
      end

      it 'closed project for invited user ' do
        expect(page).to have_content opened_project.name
        expect(page).to have_content closed_project_for_invite.name
        validate_projects_links({closed: closed_project_for_invite, opened: opened_project}, expect: true)
        expect(page).not_to have_content closed_project.name
        validate_projects_links({closed: closed_project}, expect: false)
      end

      it 'success go to closed project for invited user ' do
        find_link("go_to_closed_project_#{closed_project_for_invite.id}", text: "Перейти к процедуре", href: "/project/#{closed_project_for_invite.id}").click
        validate_default_links_and_sidebar(closed_project_for_invite, user)
        validate_not_have_admin_links_for_user(project)
        validation_visit_links_for_user(closed_project_for_invite, user)
      end

      xit 'success refirect if closed stage ' do
        find_link("go_to_closed_project_#{closed_project_for_invite.id}", text: "Перейти к процедуре", href: "/project/#{closed_project_for_invite.id}").click
        visit discontent_posts_path(closed_project_for_invite)
        expect(page.current_path).to eq aspect_posts_path(closed_project_for_invite)
      end
    end
  end


  context 'moderator sign in', js: true do
    before do
      sign_in moderator
      visit root_path
    end

    it_behaves_like 'not_have_content_for_not_auth_user'

    it_behaves_like 'have_content_for_moderator'

    it 'have base link ' do
      expect(page).to have_link('sign_out', text: 'Выйти', href: destroy_user_session_path)
    end

    it 'success sign out ', js: true do
      click_link 'sign_out'
      expect(page).to have_link('sign_in', text: 'Войти')
      expect(page).to have_link('sign_up', text: 'Зарегистрироваться')
    end

    context 'success redirect to root path ' do
      before do
        visit "/project/#{closed_project.id}"
      end

      it 'for closed project ' do
        expect(page.current_path).to eq root_path
      end

      it 'for next_stage closed project' do
        expect {
          custom_method_submit(:put, "/project/#{closed_project.id}/next_stage")
          expect(page.current_path).to eq root_path
        }.to_not change { closed_project.reload.stage }
      end

      it 'for pr_stage closed project' do
        expect {
          custom_method_submit(:put, "/project/#{closed_project.id}/prev_stage")
          expect(page.current_path).to eq root_path
        }.to_not change { closed_project.reload.stage }
      end
    end

    context 'success current links for invite project ' do
      before do
        create_invite_for_user(closed_project_for_invite, moderator)
        create_intro_for_user(closed_project_for_invite, moderator)
        visit "/project/#{closed_project_for_invite.id}"
      end

      it 'for invite project ' do
        expect(page.current_path).to eq aspect_posts_path(closed_project_for_invite)
      end

      it 'for next_stage invite project' do
        expect(page).to have_link('open_next_stage', href: "/project/#{closed_project_for_invite.id}/next_stage")
        expect {
          click_link 'open_next_stage'
          expect(page.current_path).to eq aspect_posts_path(closed_project_for_invite)
        }.to change { closed_project_for_invite.reload.stage }.from("1:0").to("1:1")
      end

      it 'for pr_stage invite project' do
        closed_project_for_invite.update_attributes(stage: '1:1')
        refresh_page
        expect(page).to have_link('open_prev_stage', href: "/project/#{closed_project_for_invite.id}/prev_stage")
        expect {
          click_link 'open_prev_stage'
          expect(page.current_path).to eq aspect_posts_path(closed_project_for_invite)
        }.to change { closed_project_for_invite.reload.stage }.from("1:1").to("1:0")
      end
    end

    context 'have content ' do
      before do
        create_invite_for_user(closed_project_for_invite, moderator)
        create_intro_for_user(closed_project_for_invite, moderator)
        visit root_path
      end

      it 'closed project for invited user ' do
        expect(page).to have_content opened_project.name
        expect(page).to have_content closed_project_for_invite.name
        validate_projects_links({closed: closed_project_for_invite, opened: opened_project}, expect: true)
      end

      it 'success go to closed project for invited user ' do
        find_link("go_to_closed_project_#{closed_project_for_invite.id}", text: "Перейти к процедуре", href: "/project/#{closed_project_for_invite.id}").click
        validate_default_links_and_sidebar(closed_project_for_invite, moderator)
        validation_visit_links_for_user(closed_project_for_invite, moderator)
      end

      xit 'success refirect if closed stage ' do
        find_link("go_to_closed_project_#{closed_project_for_invite.id}", text: "Перейти к процедуре", href: "/project/#{closed_project_for_invite.id}").click
        visit discontent_posts_path(closed_project_for_invite)
        expect(page.current_path).to eq aspect_posts_path(closed_project_for_invite)
      end
    end
  end
end
