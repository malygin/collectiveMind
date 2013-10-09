class Journal < ActiveRecord::Base
  attr_accessible :body, :type_event, :user, :project
  belongs_to :user
  belongs_to :project, :class_name => 'Core::Project', :foreign_key => "project_id"
  @types = %w(essay_post_save
 essay_comment_save
 add_score
 add_score_essay
 add_score_anal
 concept_post_revision
 concept_post_acceptance
 concept_post_rejection
 concept_post_to_expert
 concept_comment_save
 concept_post_save
 plan_post_revision
 plan_post_acceptance
 plan_post_rejection
 plan_post_to_expert
 plan_comment_save
 plan_post_save
 plan_post_update
 discontent_post_save
 discontent_comment_save
 discontent_post_update
 discontent_post_to_expert
 discontent_post_acceptance
 discontent_post_rejection
 discontent_post_revision
 life_tape_post_save
 life_tape_comment_save
 concept_post_update
 question_post_save
 question_comment_save
 expert_news_comment_save
 expert_news_post_save
 estimate_post_save
 estimate_post_update
 estimate_comment_
 save answer_save
 estimate_post_rejection
 estimate_post_acceptance)

  def self.events_for_user_feed(project_id, lim = 20)

		Journal.where(" project_id = (?) AND type_event IN (?)",project_id, @types).limit(lim).order('created_at DESC')
  end

  def self.events_for_user_show(project_id, user_id, lim = 9)

		Journal.where(" project_id = (?) AND type_event IN (?)",project_id, @types).where("user_id= (?)", user_id).limit(lim).order('created_at DESC')
	end
end
