include SessionsHelper
include ApplicationHelper

def sign_in user
  visit new_user_session_path
  fill_in 'user_email', with: user.email
  fill_in 'user_password', with: 'pascal2003'
  click_button 'sign_in'
end

def sign_out
  click_link 'sign_out'
end

def create_invite_for_user(project, user)
  create :core_project_user, project_id: project.id, user_id: user.id
end

def validation_visit_links_for_user(project, user)
  # validate journal
  visit journals_path(project)
  expect(page).to have_content 'События'
  expect(page).to have_selector "a", 'вернуться к процедуре'

  # validate knowbase
  visit knowbase_posts_path(project)
  expect(page).to have_selector "a", 'вернуться к процедуре'

  # validate help
  visit help_posts_path(project)
  expect(page).to have_selector "a", 'вернуться к процедуре'

  # validate rating
  visit users_path(project)
  expect(page).to have_content 'Рейтинг участников'
  expect(page).to have_selector "a", 'вернуться к процедуре'

  # validate profile
  visit user_path(project, user)
  expect(page).to have_content user.to_s
  expect(page).to have_content 'Достижения' unless user.boss?

  # validate edit profile
  visit edit_user_path(project, user)
  expect(page).to have_content 'Отредактируйте информацию о себе'
end

def validation_visit_not_have_links_for_user(project, user)
  # validate knowbase
  visit knowbase_posts_path(project)
  expect(page).to have_selector "a", 'вернуться к процедуре'
  expect(page).not_to have_link('new_knowbase_post', text: '+добавить статью', href: new_knowbase_post_path(project))

  # validate club rating
  visit users_rc_users_path(project)
  expect(page.current_path).to eq root_path

  # validate next_stage
  visit next_stage_core_project_path(project)
  expect(page.current_path).to eq root_path

  # validate pr_stage
  visit pr_stage_core_project_path(project)
  expect(page.current_path).to eq root_path

  # validate profile
  visit user_path(project, user)
  expect(page).to have_content user.to_s
  expect(page).to have_content 'Достижения'
  expect(page).not_to have_link("club_status_#{user.id}", href: club_toggle_user_path(project, user))
  expect(page).not_to have_link("userscore_#{user.id}", href: update_score_user_path(project, user))
end

def validation_visit_not_have_links_for_moderator(project, user)
  # validate next_stage
  visit next_stage_core_project_path(project)
  expect(page.current_path).to eq root_path

  # validate pr_stage
  visit pr_stage_core_project_path(project)
  expect(page.current_path).to eq root_path

  # validate profile
  visit user_path(project, user)
  expect(page).to have_content user.to_s
  expect(page).not_to have_link("club_status_#{user.id}", href: club_toggle_user_path(project, user))
  expect(page).not_to have_link("userscore_#{user.id}", href: update_score_user_path(project, user))
end

def validation_visit_links_for_moderator(project)
  # validate knowbase
  visit knowbase_posts_path(project)
  expect(page).to have_selector "a", 'вернуться к процедуре'
  expect(page).to have_link('new_knowbase_post', text: '+добавить статью', href: new_knowbase_post_path(project))

  # validate club rating
  visit users_rc_users_path(project)
  expect(page).to have_selector "a", 'вернуться к процедуре'
  expect(page).to have_content 'Клубный рейтинг участников'
end

def validate_not_have_admin_links_for_user(project)
  expect(page).not_to have_content 'Настройки Администратора'
  expect(page).not_to have_link('change_stage', href: next_stage_core_project_path(project))
  expect(page).not_to have_link('list_projects', text: 'Список процедур', href: list_projects_path)
end

def validate_not_have_admin_links_for_moderator(project)
  expect(page).not_to have_link('change_stage', href: next_stage_core_project_path(project))
  expect(page).not_to have_link('list_projects', text: 'Список процедур', href: list_projects_path)
end

def validate_not_have_moderator_links_for_user(project)
  expect(page).not_to have_link('go_to_club_rating', text: 'Клубный рейтинг', href: users_rc_users_path(project))
  expect(page).not_to have_link('new_aspect', text: '+ Добавить новую тему', href: new_core_aspect_path(project))
end

def validate_have_prime_admin_links(project)
  expect(page).to have_content 'Настройки Администратора'
  expect(page).to have_link('change_stage', href: next_stage_core_project_path(project))
  expect(page).to have_link('list_projects', text: 'Список процедур', href: list_projects_path)
end

def validate_have_moderator_links(project)
  expect(page).to have_link('new_aspect', text: I18n.t('link.new_aspect'), href: new_core_aspect_path(project))
end

def validate_default_links_and_sidebar(project, user)
  visit "/project/#{project.id}"

  expect(page).to have_link('go_to_logo', text: 'MASS DECISION', href: "/project/#{project.id}")
  expect(page).to have_content project.name

  expect(page).to have_link('go_to_work', text: I18n.t('menu.help_stage'))
  expect(page).to have_link('go_to_help', text: 'Помощь', href: help_posts_path(project))
  expect(page).to have_link('go_to_knowbase', text: 'База знаний', href: knowbase_posts_path(project))
  expect(page).to have_link('go_to_rating', text: 'Рейтинг', href: users_path(project))
  expect(page).to have_link('go_to_journals', text: 'Новости', href: journals_path(project))
  expect(page).to have_link('go_to_edit_profile', text: 'Редактировать профиль', href: edit_user_path(project, user))
  expect(page).to have_link('go_to_profile', href: user_path(project, user))
  expect(page).to have_link('sign_out', href: destroy_user_session_path)

  expect(page).to have_link('go_to_aspect_posts', text: "1 СТАДИЯ: Введение в процедуру", href: aspect_posts_path(project))
  expect(page).to have_link('go_to_discontent_posts', text: "2")
  expect(page).to have_link('go_to_concept_posts', text: "3")
  expect(page).to have_link('go_to_novation_posts', text: "4")
  expect(page).to have_link('go_to_plan_posts', text: "5")
  expect(page).to have_link('go_to_estimate_posts', text: "6")
  expect(page).to have_link('go_to_comletion_proc_posts', text: "7")
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
