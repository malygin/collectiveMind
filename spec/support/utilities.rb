include SessionsHelper
include ApplicationHelper

def sign_in user
  visit new_user_session_path
  fill_in 'user_email', with: user.email
  fill_in 'user_password', with: 'pascal2003'
  click_button 'sign_in'
end

def sign_out
  visit root_path
  click_link 'sign_out'
end

def create_invite_for_user(project, user)
  create :core_project_user, project_id: project.id, user_id: user.id
end

def create_intro_for_user(project, user)
  create :user_check, user: user, project: project, check_field: 'aspect_posts_intro'
end

def validation_visit_links_for_user(project, user)
  # validate rating
  visit users_path(project)
  expect(page).to have_content 'Участник'

  # validate profile
  visit user_path(project, user)
  expect(page).to have_content 'Изменить'
  expect(page).to have_content 'Контент'
  expect(page).to have_content 'Профиль'
end

def validate_not_have_admin_links_for_user(project)
  visit "/project/#{project.id}"
  expect(page).not_to have_link('open_prev_stage', href: "/project/#{project.id}/prev_stage")
  expect(page).not_to have_link('open_next_stage', href: "/project/#{project.id}/next_stage")
end

def validate_default_links_and_sidebar(project, user)
  visit "/project/#{project.id}"

  expect(page).to have_link('go_to_logo', href: "/project/#{project.id}")
  expect(page).to have_content project.name

  expect(page).to have_link('open_procedure', text: 'Процедура', href: "/project/#{project.id}")
  expect(page).to have_link('open_cabinet', text: 'Кабинет', href: new_aspect_post_path(project, type_mechanic: 'simple'))
  expect(page).to have_link('clear_my_journals', text: 'Мои уведомления', href: journal_clear_user_path(project, user))
  expect(page).to have_link('open_rating', text: 'Рейтинг', href: users_path(project))
  expect(page).to have_link('tooltip_db', text: 'База знаний', href: knowbase_posts_path(project))
  expect(page).to have_button('open_expert_news')
  expect(page).to have_link('auth_dropdown')
  click_link 'auth_dropdown'
  expect(page).to have_link('go_to_profile', text: 'Профиль', href: user_path(project, user))
  expect(page).to have_link('sign_out', text: 'Выйти', href: destroy_user_session_path)

  expect(page).to have_link('go_to_aspect_posts', text: '1 СТАДИЯ: Введение в процедуру', href: aspect_posts_path(project))
  expect(page).to have_link('go_to_discontent_posts', text: '2')
  expect(page).to have_link('go_to_concept_posts', text: '3')
  expect(page).to have_link('go_to_novation_posts', text: '4')
  expect(page).to have_link('go_to_plan_posts', text: '5')
  expect(page).to have_link('go_to_estimate_posts', text: '6')
  # expect(page).to have_link('go_to_comletion_posts', text: '7')
end

def validate_projects_links(projects, expect)
  if projects[:opened]
    if expect[:expect]
      expect(page).to have_link('go_to_opened_project_'+projects[:opened].id.to_s, text: I18n.t('link.go_to_project'), href: "/project/#{projects[:opened].id}")
    else
      expect(page).not_to have_link('go_to_opened_project_'+projects[:opened].id.to_s, text: I18n.t('link.go_to_project'), href: "/project/#{projects[:opened].id}")
    end
  end
  if projects[:closed]
    if expect[:expect]
      expect(page).to have_link('go_to_closed_project_'+projects[:closed].id.to_s, text: I18n.t('link.go_to_project'), href: "/project/#{projects[:closed].id}")
    else
      expect(page).not_to have_link('go_to_closed_project_'+projects[:closed].id.to_s, text: I18n.t('link.go_to_project'), href: "/project/#{projects[:closed].id}")
    end
  end
end

def custom_method_submit(method, path)
  current_driver = Capybara.current_driver
  Capybara.current_driver = :rack_test
  page.driver.submit method, path, {}
  Capybara.current_driver = current_driver
end
