include SessionsHelper
include ApplicationHelper

def sign_in(user)
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

def validate_default_profile(project, user)
  click_link 'auth_dropdown'
  expect(page).to have_link('go_to_profile', text: 'Профиль', href: user_path(project, user))
  expect(page).to have_link('sign_out', text: 'Выйти', href: destroy_user_session_path)
end

def validate_default_header(project, user)
  expect(page).to have_link('go_to_logo', href: "/project/#{project.id}")
  expect(page).to have_content project.name
  expect(page).to have_link('open_procedure', text: 'Процедура', href: "/project/#{project.id}")
  expect(page).to have_link('open_cabinet', text: 'Кабинет', href: new_aspect_post_path(project, type_mechanic: 'simple'))
  expect(page).to have_link('clear_my_journals', text: 'Мои уведомления', href: journal_clear_user_path(project, user))
  expect(page).to have_link('open_rating', text: 'Рейтинг', href: users_path(project))
  expect(page).to have_link('tooltip_db', text: 'База знаний', href: knowbase_posts_path(project))
  expect(page).to have_button('open_expert_news')
end

def validate_default_links_and_sidebar(project, user)
  visit "/project/#{project.id}"
  validate_default_header(project, user)
  validate_default_profile(project, user)
  project.stages.select { |k, _| k <= 6 }.each do |num_stage, stage|
    if num_stage == 1
      stage_path = Rails.application.routes.url_helpers.send("#{stage[:type_stage]}_path", project)
      expect(page).to have_link("go_to_#{stage[:type_stage]}", text: "#{num_stage} СТАДИЯ: #{stage[:name]}", href: stage_path)
    else
      expect(page).to have_link("go_to_#{stage[:type_stage]}", text: num_stage.to_s, href: '#')
    end
  end
end

def validate_projects_links(projects, expect)
  projects.each do |type, project|
    if expect[:expect]
      expect(page).to have_link("go_to_#{type}_project_" + project.id.to_s, text: I18n.t('link.go_to_project'), href: "/project/#{project.id}")
    else
      expect(page).not_to have_link("go_to_#{type}_project_" + project.id.to_s, text: I18n.t('link.go_to_project'), href: "/project/#{project.id}")
    end
  end
end

def custom_method_submit(method, path)
  current_driver = Capybara.current_driver
  Capybara.current_driver = :rack_test
  page.driver.submit method, path, {}
  Capybara.current_driver = current_driver
end
