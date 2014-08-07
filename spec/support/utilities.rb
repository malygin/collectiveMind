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

def prepare_discontents(project)
  @aspect1 = FactoryGirl.create :aspect, project: project, content: 'aspect 1'
  @aspect2 = FactoryGirl.create :aspect, project: project, content: 'aspect 2'
  @discontent1 = FactoryGirl.create :discontent, project: project, content: 'discontent 1', whend: 'when 1', whered: 'where 1'
  @discontent2 = FactoryGirl.create :discontent, project: project, content: 'discontent 2', whend: 'when 2', whered: 'where 2'
  @disasp1 = FactoryGirl.create :discontent_post_aspect, post_id: @discontent1.id, aspect_id: @aspect1.id
  @disasp1 = FactoryGirl.create :discontent_post_aspect, post_id: @discontent2.id, aspect_id: @aspect1.id
end

