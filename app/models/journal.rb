class Journal < ActiveRecord::Base
  attr_accessible :body, :type_event, :user, :project
  belongs_to :user
  belongs_to :project, :class_name => 'Core::Project', :foreign_key => "project_id"

  def self.events_for_user_feed(project_id, lim = 9)
		types = ['add_score','concept_post_revision','concept_post_acceptance','concept_post_rejection',
			'concept_post_to_expert','concept_comment_save', 'concept_post_save',
			'plan_post_revision','plan_post_acceptance','plan_post_rejection',
			'plan_post_to_expert','plan_comment_save', 'plan_post_save','plan_post_update',

		 'discontent_post_save', 'discontent_comment_save', 'discontent_post_update', 
		 'life_tape_post_save', 'life_tape_comment_save', 'concept_post_update', 
		 'question_post_save','question_comment_save', 'expert_news_comment_save','expert_news_post_save','estimate_post_save',
		  'estimate_post_update','estimate_comment_save', 'answer_save', 'estimate_post_rejection', 'estimate_post_acceptance']
		Journal.where(" project_id = (?) AND type_event IN (?)",project_id, types).limit(lim).order('created_at DESC')
	end	
end
