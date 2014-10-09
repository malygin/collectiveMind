# encoding: utf-8

include SessionsHelper
include ApplicationHelper

def sign_in user
  visit new_user_session_path
  fill_in 'user_email', with: user.email
  fill_in 'user_password', with: 'pascal2003'
  click_button 'Signin'
end

def sign_out
  click_link 'sign_out'
end

def not_have_content_for_not_auth_user(opened_project,demo_project,closed_project,club_project)
  expect(page).not_to have_link('list_projects', :text => 'Список процедур', :href => list_projects_path)
  expect(page).not_to have_content 'Закрытые процедуры'
  expect(page).not_to have_content 'Клубные процедуры'
  expect(page).not_to have_content 'closed project'
  expect(page).not_to have_content 'club project'
  expect(page).not_to have_content 'Открытые процедуры'
  expect(page).not_to have_content 'Демо процедуры'
  expect(page).not_to have_content 'opened project'
  expect(page).not_to have_content 'demo project'
  # expect(page).not_to have_link('go_to_closed_project', :text => 'Перейти к процедуре', :href => "/project/#{closed_project.id}")
  # expect(page).not_to have_link('go_to_club_project', :text => 'Перейти к процедуре', :href => "/project/#{club_project.id}")
  # expect(page).not_to have_link('go_to_opened_project', :text => 'Перейти к процедуре', :href => "/project/#{opened_project.id}")
  # expect(page).not_to have_link('go_to_demo_project', :text => 'Перейти к процедуре', :href => "/project/#{demo_project.id}")
  validate_projects_links({closed: closed_project, opened: opened_project, demo: demo_project, club: club_project}, expect: false)
end


def not_have_content_for_ordinary_user(closed_project,club_project)
  #expect(page).not_to have_selector '#list_projects'
  #expect(page).not_to have_selector "a#list_projects[href='/list_projects']", 'Список процедур'
  expect(page).not_to have_link('list_projects', :text => 'Список процедур', :href => list_projects_path)
  expect(page).not_to have_content 'Закрытые процедуры'
  expect(page).not_to have_content 'Клубные процедуры'
  expect(page).not_to have_content 'closed project'
  expect(page).not_to have_content 'club project'
  #expect(page).not_to have_selector "a#go_to_closed_project[href='/project/#{closed_project.id}']", 'Перейти к процедуре'
  #expect(page).not_to have_selector "a#go_to_club_project[href='/project/#{club_project.id}']", 'Перейти к процедуре'
  # expect(page).not_to have_link('go_to_closed_project', :text => 'Перейти к процедуре', :href => "/project/#{closed_project.id}")
  # expect(page).not_to have_link('go_to_club_project', :text => 'Перейти к процедуре', :href => "/project/#{club_project.id}")
  validate_projects_links({closed: closed_project, club: club_project}, expect: false)
end

def have_content_for_ordinary_user(opened_project,demo_project)
  expect(page).to have_content 'Открытые процедуры'
  expect(page).to have_content 'Демо процедуры'
  expect(page).to have_content 'opened project'
  expect(page).to have_content 'demo project'
  #expect(page).to have_selector "a#go_to_opened_project[href='/project/#{opened_project.id}']", 'Перейти к процедуре'
  #expect(page).to have_selector "a#go_to_demo_project[href='/project/#{demo_project.id}']", 'Перейти к процедуре'
  # expect(page).to have_link('go_to_opened_project', :text => 'Перейти к процедуре', :href => "/project/#{opened_project.id}")
  # expect(page).to have_link('go_to_demo_project', :text => 'Перейти к процедуре', :href => "/project/#{demo_project.id}")
  validate_projects_links({opened: opened_project, demo: demo_project}, expect: true)
end

def have_content_for_invited_ordinary_user(closed_project_for_invite,opened_project,demo_project)
  expect(page).to have_content 'Закрытые процедуры'
  expect(page).to have_content 'Открытые процедуры'
  expect(page).to have_content 'Демо процедуры'
  expect(page).to have_content 'opened project'
  expect(page).to have_content 'demo project'
  expect(page).to have_content 'closed invited project'
  # expect(page).to have_link('go_to_opened_project', :text => 'Перейти к процедуре', :href => "/project/#{opened_project.id}")
  # expect(page).to have_link('go_to_demo_project', :text => 'Перейти к процедуре', :href => "/project/#{demo_project.id}")
  # expect(page).to have_link('go_to_closed_project', :text => 'Перейти к процедуре', :href => "/project/#{closed_project_for_invite.id}")
  validate_projects_links({closed: closed_project_for_invite, opened: opened_project, demo: demo_project}, expect: true)
end

def not_have_content_for_invited_ordinary_user(closed_project,club_project)
  expect(page).not_to have_link('list_projects', :text => 'Список процедур', :href => list_projects_path)
  expect(page).not_to have_content 'closed project'
  expect(page).not_to have_content 'Клубные процедуры'
  expect(page).not_to have_content 'club project'
  # expect(page).not_to have_link('go_to_closed_project', :text => 'Перейти к процедуре', :href => "/project/#{closed_project.id}")
  # expect(page).not_to have_link('go_to_club_project', :text => 'Перейти к процедуре', :href => "/project/#{club_project.id}")
  validate_projects_links({closed: closed_project,club: club_project}, expect: false)
end

def not_have_content_for_club_user(closed_project)
  #expect(page).not_to have_selector '#list_projects'
  expect(page).not_to have_link('list_projects', :text => 'Список процедур', :href => list_projects_path)
  expect(page).not_to have_content 'Закрытые процедуры'
  expect(page).not_to have_content 'closed project'
  #expect(page).not_to have_selector "a#go_to_closed_project[href='/project/#{closed_project.id}']", 'Перейти к процедуре'
  # expect(page).not_to have_link('go_to_closed_project', :text => 'Перейти к процедуре', :href => "/project/#{closed_project.id}")
  validate_projects_links({closed: closed_project}, expect: false)
end

def have_content_for_club_user(opened_project,demo_project,club_project)
  expect(page).to have_content 'Открытые процедуры'
  expect(page).to have_content 'Демо процедуры'
  expect(page).to have_content 'Клубные процедуры'
  expect(page).to have_content 'opened project'
  expect(page).to have_content 'demo project'
  expect(page).to have_content 'club project'
  #expect(page).to have_selector "a#go_to_opened_project[href='/project/#{opened_project.id}']", 'Перейти к процедуре'
  #expect(page).to have_selector "a#go_to_demo_project[href='/project/#{demo_project.id}']", 'Перейти к процедуре'
  #expect(page).to have_selector "a#go_to_club_project[href='/project/#{club_project.id}']", 'Перейти к процедуре'
  # expect(page).to have_link('go_to_open_project_'+opened_project.id, :text => 'Перейти к процедуре', :href => "/project/#{opened_project.id}")
  # expect(page).to have_link('go_to_demo_project_'+demo_project.id, :text => 'Перейти к процедуре', :href => "/project/#{demo_project.id}")
  # expect(page).to have_link('go_to_club_project_'+club_project.id, :text => 'Перейти к процедуре', :href => "/project/#{club_project.id}")
  validate_projects_links({opened: opened_project, demo: demo_project, club: club_project}, expect: true)
end

def have_content_for_invited_club_user(closed_project_for_invite,opened_project,demo_project,club_project)
  expect(page).to have_content 'Закрытые процедуры'
  expect(page).to have_content 'Открытые процедуры'
  expect(page).to have_content 'Демо процедуры'
  expect(page).to have_content 'Клубные процедуры'
  expect(page).to have_content 'opened project'
  expect(page).to have_content 'demo project'
  expect(page).to have_content 'club project'
  expect(page).to have_content 'closed invited project'
  # expect(page).to have_link('go_to_opened_project', :text => 'Перейти к процедуре', :href => "/project/#{opened_project.id}")
  # expect(page).to have_link('go_to_demo_project', :text => 'Перейти к процедуре', :href => "/project/#{demo_project.id}")
  # expect(page).to have_link('go_to_closed_project', :text => 'Перейти к процедуре', :href => "/project/#{closed_project_for_invite.id}")
  # expect(page).to have_link('go_to_club_project', :text => 'Перейти к процедуре', :href => "/project/#{club_project.id}")
  validate_projects_links({closed: closed_project_for_invite, opened: opened_project, demo: demo_project, club: club_project}, expect: true)
end

def not_have_content_for_invited_club_user(closed_project)
  expect(page).not_to have_link('list_projects', :text => 'Список процедур', :href => list_projects_path)
  expect(page).not_to have_content 'closed project'
  # expect(page).not_to have_link('go_to_closed_project', :text => 'Перейти к процедуре', :href => "/project/#{closed_project.id}")
  validate_projects_links({closed: closed_project}, expect: false)
end

def not_have_content_for_moderator(closed_project)
  #expect(page).not_to have_selector '#list_projects'
  expect(page).not_to have_link('list_projects', :text => 'Список процедур', :href => list_projects_path)
  expect(page).not_to have_content 'Закрытые процедуры'
  expect(page).not_to have_content 'closed project'
  #expect(page).not_to have_selector "a#go_to_closed_project[href='/project/#{closed_project.id}']", 'Перейти к процедуре'
  # expect(page).not_to have_link('go_to_closed_project', :text => 'Перейти к процедуре', :href => "/project/#{closed_project.id}")
  validate_projects_links({closed: closed_project}, expect: false)
end

def have_content_for_moderator(opened_project,demo_project,club_project)
  expect(page).to have_content 'Открытые процедуры'
  expect(page).to have_content 'Демо процедуры'
  expect(page).to have_content 'Клубные процедуры'
  expect(page).to have_content 'opened project'
  expect(page).to have_content 'demo project'
  expect(page).to have_content 'club project'
  #expect(page).to have_selector "a#go_to_opened_project[href='/project/#{opened_project.id}']", 'Перейти к процедуре'
  #expect(page).to have_selector "a#go_to_demo_project[href='/project/#{demo_project.id}']", 'Перейти к процедуре'
  #expect(page).to have_selector "a#go_to_club_project[href='/project/#{club_project.id}']", 'Перейти к процедуре'
  # expect(page).to have_link('go_to_opened_project', :text => 'Перейти к процедуре', :href => "/project/#{opened_project.id}")
  # expect(page).to have_link('go_to_demo_project', :text => 'Перейти к процедуре', :href => "/project/#{demo_project.id}")
  # expect(page).to have_link('go_to_club_project', :text => 'Перейти к процедуре', :href => "/project/#{club_project.id}")
  validate_projects_links({opened: opened_project, demo: demo_project, club: club_project}, expect: true)
end

def have_content_for_invited_moderator(closed_project_for_invite,opened_project,demo_project,club_project)
  expect(page).to have_content 'Закрытые процедуры'
  expect(page).to have_content 'Открытые процедуры'
  expect(page).to have_content 'Демо процедуры'
  expect(page).to have_content 'Клубные процедуры'
  expect(page).to have_content 'opened project'
  expect(page).to have_content 'demo project'
  expect(page).to have_content 'club project'
  expect(page).to have_content 'closed invited project'
  # expect(page).to have_link('go_to_opened_project', :text => 'Перейти к процедуре', :href => "/project/#{opened_project.id}")
  # expect(page).to have_link('go_to_demo_project', :text => 'Перейти к процедуре', :href => "/project/#{demo_project.id}")
  # expect(page).to have_link('go_to_closed_project', :text => 'Перейти к процедуре', :href => "/project/#{closed_project_for_invite.id}")
  # expect(page).to have_link('go_to_club_project', :text => 'Перейти к процедуре', :href => "/project/#{club_project.id}")
  validate_projects_links({closed: closed_project_for_invite, opened: opened_project, demo: demo_project, club: club_project}, expect: true)
end

def not_have_content_for_invited_moderator(closed_project)
  expect(page).not_to have_link('list_projects', :text => 'Список процедур', :href => list_projects_path)
  expect(page).not_to have_content 'closed project'
  # expect(page).not_to have_link('go_to_closed_project', :text => 'Перейти к процедуре', :href => "/project/#{closed_project.id}")
  validate_projects_links({closed: closed_project}, expect: false)
end

def have_content_for_prime_admin(closed_project,opened_project,demo_project,club_project)
  #expect(page).to have_selector '#list_projects'
  expect(page).to have_link('list_projects', :text => 'Список процедур', :href => list_projects_path)
  expect(page).to have_content 'Открытые процедуры'
  expect(page).to have_content 'Закрытые процедуры'
  expect(page).to have_content 'Демо процедуры'
  expect(page).to have_content 'Клубные процедуры'
  expect(page).to have_content 'opened project'
  expect(page).to have_content 'closed project'
  expect(page).to have_content 'demo project'
  expect(page).to have_content 'club project'
  #expect(page).to have_selector "a#go_to_opened_project[href='/project/#{opened_project.id}']", 'Перейти к процедуре'
  #expect(page).to have_selector "a#go_to_closed_project[href='/project/#{closed_project.id}']", 'Перейти к процедуре'
  #expect(page).to have_selector "a#go_to_demo_project[href='/project/#{demo_project.id}']", 'Перейти к процедуре'
  #expect(page).to have_selector "a#go_to_club_project[href='/project/#{club_project.id}']", 'Перейти к процедуре'
  # expect(page).to have_link('go_to_opened_project', :text => 'Перейти к процедуре', :href => "/project/#{opened_project.id}")
  # expect(page).to have_link('go_to_demo_project', :text => 'Перейти к процедуре', :href => "/project/#{demo_project.id}")
  # expect(page).to have_link('go_to_closed_project', :text => 'Перейти к процедуре', :href => "/project/#{closed_project.id}")
  # expect(page).to have_link('go_to_club_project', :text => 'Перейти к процедуре', :href => "/project/#{club_project.id}")
  validate_projects_links({closed: closed_project, opened: opened_project, demo: demo_project, club: club_project}, expect: true)
end

def create_invite_for_user(project,user)
  FactoryGirl.create :core_project_user, project_id: project.id, user_id: user.id
end

def validation_visit_links_for_user(project,user)
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
  visit user_path(project,user)
  expect(page).to have_content user.to_s
  expect(page).to have_content 'Достижения'

  # validate edit profile
  visit edit_user_path(project,user)
  expect(page).to have_content 'Отредактируйте информацию о себе'
end

def validation_visit_not_have_links_for_user(project,user)
  # validate knowbase
  visit knowbase_posts_path(project)
  expect(page).to have_selector "a", 'вернуться к процедуре'
  expect(page).not_to have_link('new_knowbase_post', :text => '+добавить статью', :href => new_knowbase_post_path(project))

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
  visit user_path(project,user)
  expect(page).to have_content user.to_s
  expect(page).to have_content 'Достижения'
  expect(page).not_to have_link("club_status_#{user.id}", :href => club_toggle_user_path(project,user))
  expect(page).not_to have_link("userscore_#{user.id}", :href => update_score_user_path(project,user))
end

def validation_visit_not_have_links_for_moderator(project,user)
  # validate next_stage
  visit next_stage_core_project_path(project)
  expect(page.current_path).to eq root_path

  # validate pr_stage
  visit pr_stage_core_project_path(project)
  expect(page.current_path).to eq root_path

  # validate profile
  visit user_path(project,user)
  expect(page).to have_content user.to_s
  expect(page).to have_content 'Достижения'
  expect(page).not_to have_link("club_status_#{user.id}", :href => club_toggle_user_path(project,user))
  expect(page).not_to have_link("userscore_#{user.id}", :href => update_score_user_path(project,user))
end

def validation_visit_links_for_moderator(project)
  # validate knowbase
  visit knowbase_posts_path(project)
  expect(page).to have_selector "a", 'вернуться к процедуре'
  expect(page).to have_link('new_knowbase_post', :text => '+добавить статью', :href => new_knowbase_post_path(project))

  # validate club rating
  visit users_rc_users_path(project)
  expect(page).to have_selector "a", 'вернуться к процедуре'
  expect(page).to have_content 'Клубный рейтинг участников'
end

def validate_not_have_admin_links_for_user(project)
  expect(page).not_to have_content 'Настройки Администратора'
  expect(page).not_to have_link('change_stage', :href => next_stage_core_project_path(project))
  expect(page).not_to have_link('list_projects', :text => 'Список процедур', :href => list_projects_path)
end

def validate_not_have_moderator_links_for_user(project)
  expect(page).not_to have_link('go_to_club_rating', :text => 'Клубный рейтинг', :href => users_rc_users_path(project))
  expect(page).not_to have_link('new_aspect', :text => '+ Добавить новую тему', :href => new_discontent_aspect_path(project))
end

def validate_have_prime_admin_links(project)
  expect(page).to have_content 'Настройки Администратора'
  expect(page).to have_link('change_stage', :href => next_stage_core_project_path(project))
  expect(page).to have_link('list_projects', :text => 'Список процедур', :href => list_projects_path)
end
def validate_have_moderator_links(project)
  expect(page).to have_link('go_to_club_rating', :text => 'Клубный рейтинг', :href => users_rc_users_path(project))
  expect(page).to have_link('new_aspect', :text => '+ Добавить новую тему', :href => new_discontent_aspect_path(project))
end
def validate_default_links_and_sidebar(project,user)
  visit "/project/#{project.id}"

  expect(page).to have_link('go_to_logo', :text => 'MASS DECISION', :href => "/project/#{project.id}")
  expect(page).to have_content project.name
  expect(page).to have_content 'Аспекты'

  expect(page).to have_link('go_to_work', :text => 'Помощь по этапу')
  expect(page).to have_link('go_to_help', :text => 'Помощь', :href => help_posts_path(project))
  expect(page).to have_link('go_to_knowbase', :text => 'База знаний', :href => knowbase_posts_path(project))
  expect(page).to have_link('go_to_rating', :text => 'Рейтинг', :href => users_path(project))
  expect(page).to have_link('go_to_journals', :text => 'Новости', :href => journals_path(project))
  expect(page).to have_link('go_to_edit_profile', :text => 'Редактировать профиль', :href => edit_user_path(project,user))
  expect(page).to have_link('go_to_profile', :href => user_path(project,user))
  expect(page).to have_link('sign_out', :href => destroy_user_session_path)

  expect(page).to have_link('go_to_life_tape', :text => '1 этап Сбор информации', :href => life_tape_posts_path(project))
  expect(page).to have_link('go_to_discontent', :text => '2 этап Сбор несовершенств')
  expect(page).to have_link('go_to_concept', :text => '3 этап Сбор нововведений')
  expect(page).to have_link('go_to_plan', :text => '4 этап Создание проектов')
  expect(page).to have_link('go_to_estimate', :text => '5 этап Выставление оценок')
  #expect(page).to have_link('go_to_discontent', :text => '2 этап', :href => discontent_posts_path(project))
  #expect(page).to have_link('go_to_concept', :text => '3 этап', :href => concept_posts_path(project))
  #expect(page).to have_link('go_to_plan', :text => '4 этап', :href => plan_posts_path(project))
  #expect(page).to have_link('go_to_estimate', :text => '5 этап', :href => estimate_posts_path(project))
end

def validate_projects_links(projects, expect)
  if projects[:opened]
    if expect[:expect]
      expect(page).to have_link('go_to_opened_project_'+projects[:opened].id.to_s, :text => I18n.t('link.go_to_project'), :href => "/project/#{projects[:opened].id}")
    else
      expect(page).not_to have_link('go_to_opened_project_'+projects[:opened].id.to_s, :text => I18n.t('link.go_to_project'), :href => "/project/#{projects[:opened].id}")
    end
  end
  if projects[:closed]
    if expect[:expect]
      expect(page).to have_link('go_to_closed_project_'+projects[:closed].id.to_s, :text => I18n.t('link.go_to_project'), :href => "/project/#{projects[:closed].id}")
    else
      expect(page).not_to have_link('go_to_closed_project_'+projects[:closed].id.to_s, :text => I18n.t('link.go_to_project'), :href => "/project/#{projects[:closed].id}")
    end
  end
  if projects[:club]
    if expect[:expect]
      expect(page).to have_link('go_to_club_project_'+projects[:club].id.to_s, :text => I18n.t('link.go_to_project'), :href => "/project/#{projects[:club].id}")
    else
      expect(page).not_to have_link('go_to_club_project_'+projects[:club].id.to_s, :text => I18n.t('link.go_to_project'), :href => "/project/#{projects[:club].id}")
    end
  end
  if projects[:demo]
    if expect[:expect]
      expect(page).to have_link('go_to_demo_project_'+projects[:demo].id.to_s, :text => I18n.t('link.go_to_project'), :href => "/project/#{projects[:demo].id}")
    else
      expect(page).not_to have_link('go_to_demo_project_'+projects[:demo].id.to_s, :text => I18n.t('link.go_to_project'), :href => "/project/#{projects[:demo].id}")
    end
  end
end

def prepare_life_tape(project,user)
  @aspect1 = FactoryGirl.create :discontent_aspect, project: project, content: 'aspect 1'
  @aspect2 = FactoryGirl.create :discontent_aspect, project: project, content: 'aspect 2'
  @post1 = FactoryGirl.create :life_tape_post, project: project
  @post2 = FactoryGirl.create :life_tape_post, project: project
  @aspect_post1 = ActiveRecord::Base.connection.execute("insert into discontent_aspects_life_tape_posts (discontent_aspect_id,life_tape_post_id) values (#{@aspect1.id},#{@post1.id})")
  @aspect_post1 = ActiveRecord::Base.connection.execute("insert into discontent_aspects_life_tape_posts (discontent_aspect_id,life_tape_post_id) values (#{@aspect2.id},#{@post2.id})")
  @comment1 = FactoryGirl.create :life_tape_comment, post: @post1, user: user, content: 'comment 1'
end

def prepare_awards
  FactoryGirl.create :award, name: "1 лайк модератора", url: "1like", position: 1
  FactoryGirl.create :award, name: "3 лайка модератора", url: "3likes", position: 2
  FactoryGirl.create :award, name: "5 лайков модератора", url: "5likes", position: 3
  FactoryGirl.create :award, name: "15 лайков модератора", url: "15likes", position: 4
  FactoryGirl.create :award, name: "50 лайков модератора", url: "50likes", position: 5
  FactoryGirl.create :award, name: "Первое несовершенство в аспекте", url: "1stimperfection", position: 6
  FactoryGirl.create :award, name: "1 несовершенство в аспекте", url: "1imperfection", position: 7
  FactoryGirl.create :award, name: "3 несовершенства в аспекте", url: "3imperfection", position: 8
  FactoryGirl.create :award, name: "5 несовершенств в аспекте", url: "5imperfection", position: 9
  FactoryGirl.create :award, name: "15 и более несовершенств в аспекте", url: "15imperfection", position: 10
  FactoryGirl.create :award, name: "50 процентов и более несовершенств одного автора в одном аспекте", url: "50imperfection", position: 11
  FactoryGirl.create :award, name: "Первое нововведение в аспекте", url: "1stinnovation", position: 12
  FactoryGirl.create :award, name: "1 нововведение в аспекте", url: "1innovation", position: 13
  FactoryGirl.create :award, name: "3 нововведение в аспекте", url: "3innovation", position: 14
  FactoryGirl.create :award, name: "5 нововведение в аспекте", url: "5innovation", position: 15
  FactoryGirl.create :award, name: "15 и более нововведений в аспекте", url: "15innovation", position: 16
  FactoryGirl.create :award, name: "50 процентов и более нововведений одного автора в одном аспекте", url: "50innovation", position: 17
  FactoryGirl.create :award, name: "За проект", url: "project", position: 18
  FactoryGirl.create :award, name: "100 очков рейтинга", url: "100points", position: 19
  FactoryGirl.create :award, name: "500 очков рейтинга", url: "500points", position: 20
  FactoryGirl.create :award, name: "1000 очков рейтинга", url: "1000points", position: 21
  FactoryGirl.create :award, name: "3000 рейтинга и более", url: "3000points", position: 22
end

def prepare_discontents(project,user)
  #@todo нужны ассоциации, чтобы сперва создать аспект, потом дисконтент со связью
  @aspect1 = FactoryGirl.create :aspect, project: project, content: 'aspect 1'
  @aspect2 = FactoryGirl.create :aspect, project: project, content: 'aspect 2'
  @discontent1 = FactoryGirl.create :discontent, project: project,user: user, content: 'discontent 1', whend: 'when 1', whered: 'where 1'
  @discontent2 = FactoryGirl.create :discontent, project: project,user: user, content: 'discontent 2', whend: 'when 2', whered: 'where 2'
  @disasp1 = FactoryGirl.create :discontent_post_aspect, post_id: @discontent1.id, aspect_id: @aspect1.id
  @disasp1 = FactoryGirl.create :discontent_post_aspect, post_id: @discontent2.id, aspect_id: @aspect1.id
  @comment1 = FactoryGirl.create :discontent_comment, post: @discontent1, user: user, content: 'comment 1'
end

def prepare_for_vote_discontents(project)
  @discontent_group1 = FactoryGirl.create :discontent, project: project, status: 2, content: 'discontent group 1', whend: 'when group 1', whered: 'where group 1'
end

def prepare_concepts(project,user)
  @aspect1 = FactoryGirl.create :aspect, project: project, content: 'aspect 1'
  @aspect2 = FactoryGirl.create :aspect, project: project, content: 'aspect 2'
  @discontent1 = FactoryGirl.create :discontent, project: project, status:4, content: 'discontent 1', whend: 'when 1', whered: 'where 1'
  @discontent2 = FactoryGirl.create :discontent, project: project, status:4, content: 'discontent 2', whend: 'when 2', whered: 'where 2'
  @disasp1 = FactoryGirl.create :discontent_post_aspect, post_id: @discontent1.id, aspect_id: @aspect1.id
  @disasp1 = FactoryGirl.create :discontent_post_aspect, post_id: @discontent2.id, aspect_id: @aspect1.id

  @concept1 = FactoryGirl.create :concept,user: user, project: project
  @concept2 = FactoryGirl.create :concept,user: user, project: project
  @concept_aspect1 = FactoryGirl.create :concept_aspect, discontent_aspect_id: @discontent1.id, concept_post_id: @concept1.id,positive:'positive 1', negative: 'negative 1', title: 'title 1', control:'control 1', content:'content 1',reality:'reality 1',problems:'problems 1',name:'name 1'
  @concept_aspect2 = FactoryGirl.create :concept_aspect, discontent_aspect_id: @discontent1.id, concept_post_id: @concept2.id,positive:'positive 2', negative: 'negative 2', title: 'title 2', control:'control 2', content:'content 2',reality:'reality 2',problems:'problems 2',name:'name 2'
  @condis1 = FactoryGirl.create :concept_post_discontent, post_id: @concept1.id, discontent_post_id: @discontent1.id
  @condis2 = FactoryGirl.create :concept_post_discontent, post_id: @concept2.id, discontent_post_id: @discontent1.id
  @comment1 = FactoryGirl.create :concept_comment, post: @concept1, user: user, content: 'comment 1'
end

def prepare_plans(project)
  @aspect1 = FactoryGirl.create :aspect, project: project, content: 'aspect 1'
  @aspect2 = FactoryGirl.create :aspect, project: project, content: 'aspect 2'
  @discontent1 = FactoryGirl.create :discontent, project: project, status:4, content: 'discontent 1', whend: 'when 1', whered: 'where 1'
  @discontent2 = FactoryGirl.create :discontent, project: project, status:4, content: 'discontent 2', whend: 'when 2', whered: 'where 2'
  @disasp1 = FactoryGirl.create :discontent_post_aspect, post_id: @discontent1.id, aspect_id: @aspect1.id
  @disasp1 = FactoryGirl.create :discontent_post_aspect, post_id: @discontent2.id, aspect_id: @aspect1.id

  @concept1 = FactoryGirl.create :concept, project: project
  @concept2 = FactoryGirl.create :concept, project: project
  @concept_aspect1 = FactoryGirl.create :concept_aspect, discontent_aspect_id: @discontent1.id, concept_post_id: @concept1.id,positive:'positive 1', negative: 'negative 1', title: 'title 1', control:'control 1', content:'content 1',reality:'reality 1',problems:'problems 1',name:'name 1'
  @concept_aspect2 = FactoryGirl.create :concept_aspect, discontent_aspect_id: @discontent1.id, concept_post_id: @concept2.id,positive:'positive 2', negative: 'negative 2', title: 'title 2', control:'control 2', content:'content 2',reality:'reality 2',problems:'problems 2',name:'name 2'
  @condis1 = FactoryGirl.create :concept_post_discontent, post_id: @concept1.id, discontent_post_id: @discontent1.id
  @condis2 = FactoryGirl.create :concept_post_discontent, post_id: @concept2.id, discontent_post_id: @discontent1.id

  @plan1 = FactoryGirl.create :plan, project: project, name: 'name 1', goal: 'goal 1', content: 'content 1'
  @plan_stage1 = FactoryGirl.create :plan_stage, post_id: @plan1.id, name: 'name 1', desc: 'desc 1'
  @plan_aspect1 = FactoryGirl.create :plan_aspect, plan_post_id: @plan1.id, post_stage_id: @plan_stage1.id
  @plan_action1 = FactoryGirl.create :plan_action, plan_post_aspect_id: @plan_aspect1.id, name: 'name 1', desc: 'desc 1'
end