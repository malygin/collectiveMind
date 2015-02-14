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
  expect(page).not_to have_link('new_aspect', text: '+ Добавить новую тему', href: new_discontent_aspect_path(project))
end

def validate_have_prime_admin_links(project)
  expect(page).to have_content I18n.t('menu.settings.settings_admin')
  expect(page).to have_link('change_stage', href: next_stage_core_project_path(project))
  expect(page).to have_link('list_projects', text: I18n.t('menu.list_projects'), href: list_projects_path)
end

def validate_have_moderator_links(project)
  expect(page).to have_link('new_aspect', text: I18n.t('link.new_aspect'), href: new_discontent_aspect_path(project))
end

def validate_default_links_and_sidebar(project, user)
  visit "/project/#{project.id}"

  expect(page).to have_link('go_to_logo', text: 'MASS DECISION', href: "/project/#{project.id}")
  expect(page).to have_content project.name
  expect(page).to have_content I18n.t('menu.list_aspects')

  expect(page).to have_link('go_to_work', text: I18n.t('menu.help_stage'))
  expect(page).to have_link('go_to_help', text: I18n.t('menu.help'), href: help_posts_path(project))
  expect(page).to have_link('go_to_knowbase', text: I18n.t('menu.base_knowledge'), href: knowbase_posts_path(project))
  expect(page).to have_link('go_to_rating', text: I18n.t('menu.raiting'), href: users_path(project))
  expect(page).to have_link('go_to_journals', text: I18n.t('menu.news'), href: journals_path(project))
  expect(page).to have_link('go_to_edit_profile', text: I18n.t('menu.profile_edit'), href: edit_user_path(project, user))
  expect(page).to have_link('go_to_profile', href: user_path(project, user))
  expect(page).to have_link('sign_out', href: destroy_user_session_path)

  expect(page).to have_link('go_to_life_tape', text: "1#{I18n.t('stages.stage', count: 1)} #{I18n.t('stages.life_tape')}", href: life_tape_posts_path(project))
  expect(page).to have_link('go_to_discontent', text: "2#{I18n.t('stages.stage', count: 2)} #{I18n.t('stages.discontent')}")
  expect(page).to have_link('go_to_concept', text: "3#{I18n.t('stages.stage', count: 3)} #{I18n.t('stages.concept')}")
  expect(page).to have_link('go_to_plan', text: "4#{I18n.t('stages.stage', count: 4)} #{I18n.t('stages.plan')}")
  expect(page).to have_link('go_to_estimate', text: "5#{I18n.t('stages.stage', count: 5)} #{I18n.t('stages.estimate')}")
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
  if projects[:club]
    if expect[:expect]
      expect(page).to have_link('go_to_club_project_'+projects[:club].id.to_s, text: I18n.t('link.go_to_project'), href: "/project/#{projects[:club].id}")
    else
      expect(page).not_to have_link('go_to_club_project_'+projects[:club].id.to_s, text: I18n.t('link.go_to_project'), href: "/project/#{projects[:club].id}")
    end
  end
  if projects[:demo]
    if expect[:expect]
      expect(page).to have_link('go_to_demo_project_'+projects[:demo].id.to_s, text: I18n.t('link.go_to_project'), href: "/project/#{projects[:demo].id}")
    else
      expect(page).not_to have_link('go_to_demo_project_'+projects[:demo].id.to_s, text: I18n.t('link.go_to_project'), href: "/project/#{projects[:demo].id}")
    end
  end
end

def prepare_awards
  create :award, name: '1 лайк модератора', url: '1like', position: 1
  create :award, name: '3 лайка модератора', url: '3likes', position: 2
  create :award, name: '5 лайков модератора', url: '5likes', position: 3
  create :award, name: '15 лайков модератора', url: '15likes', position: 4
  create :award, name: '50 лайков модератора', url: '50likes', position: 5
  create :award, name: 'Первое несовершенство в аспекте', url: '1stimperfection', position: 6
  create :award, name: '1 несовершенство в аспекте', url: '1imperfection', position: 7
  create :award, name: '3 несовершенства в аспекте', url: '3imperfection', position: 8
  create :award, name: '5 несовершенств в аспекте', url: '5imperfection', position: 9
  create :award, name: '15 и более несовершенств в аспекте', url: '15imperfection', position: 10
  create :award, name: '50 процентов и более несовершенств одного автора в одном аспекте', url: '50imperfection', position: 11
  create :award, name: 'Первое нововведение в аспекте', url: '1stinnovation', position: 12
  create :award, name: '1 нововведение в аспекте', url: '1innovation', position: 13
  create :award, name: '3 нововведение в аспекте', url: '3innovation', position: 14
  create :award, name: '5 нововведение в аспекте', url: '5innovation', position: 15
  create :award, name: '15 и более нововведений в аспекте', url: '15innovation', position: 16
  create :award, name: '50 процентов и более нововведений одного автора в одном аспекте', url: '50innovation', position: 17
  create :award, name: 'За проект', url: 'project', position: 18
  create :award, name: '100 очков рейтинга', url: '100points', position: 19
  create :award, name: '500 очков рейтинга', url: '500points', position: 20
  create :award, name: '1000 очков рейтинга', url: '1000points', position: 21
  create :award, name: '3000 рейтинга и более', url: '3000points', position: 22
end

def prepare_for_vote_discontents(project)
  @discontent_group1 = create :discontent, project: project, status: 2
end

def prepare_concepts(project, user)
  @aspect1 = create :aspect, project: project
  @discontent1 = create :discontent, project: project, status: 4
  create :discontent_post_aspect, post_id: @discontent1.id, aspect_id: @aspect1.id
  @discontent2 = create :discontent, project: project, status: 4
  create :discontent_post_aspect, post_id: @discontent2.id, aspect_id: @aspect1.id
  @concept1 = create :concept, user: user, project: project
  @concept2 = create :concept, user: user, project: project
  @comment1 = create :concept_comment, post: @concept1, user: user

  @concept_aspect1 = @concept1.post_aspects.first
  @concept_aspect2 = @concept2.post_aspects.first
  # @todo move to factory
  create :concept_post_discontent, post_id: @concept1.id, discontent_post_id: @discontent1.id
  create :concept_post_discontent, post_id: @concept2.id, discontent_post_id: @discontent1.id
end
