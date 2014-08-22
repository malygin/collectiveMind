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

def prepare_life_tape(project,user)
  @aspect1 = FactoryGirl.create :discontent_aspect, project: project, content: 'aspect 1'
  @aspect2 = FactoryGirl.create :discontent_aspect, project: project, content: 'aspect 2'
  @post1 = FactoryGirl.create :life_tape_post, project: project
  @post2 = FactoryGirl.create :life_tape_post, project: project
  @aspect_post1 = ActiveRecord::Base.connection.execute("insert into discontent_aspects_life_tape_posts (discontent_aspect_id,life_tape_post_id) values (#{@aspect1.id},#{@post1.id})")
  @aspect_post1 = ActiveRecord::Base.connection.execute("insert into discontent_aspects_life_tape_posts (discontent_aspect_id,life_tape_post_id) values (#{@aspect2.id},#{@post2.id})")
  @comment1 = FactoryGirl.create :life_tape_comment, post: @post1, user: user, content: 'comment 1'
end

def prepare_discontents(project,user)
  @aspect1 = FactoryGirl.create :aspect, project: project, content: 'aspect 1'
  @aspect2 = FactoryGirl.create :aspect, project: project, content: 'aspect 2'
  @discontent1 = FactoryGirl.create :discontent, project: project, content: 'discontent 1', whend: 'when 1', whered: 'where 1'
  @discontent2 = FactoryGirl.create :discontent, project: project, content: 'discontent 2', whend: 'when 2', whered: 'where 2'
  @disasp1 = FactoryGirl.create :discontent_post_aspect, post_id: @discontent1.id, aspect_id: @aspect1.id
  @disasp1 = FactoryGirl.create :discontent_post_aspect, post_id: @discontent2.id, aspect_id: @aspect1.id
  @comment1 = FactoryGirl.create :discontent_comment, post: @discontent1, user: user, content: 'comment 1'
end

def prepare_concepts(project)
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