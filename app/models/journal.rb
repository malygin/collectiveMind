class Journal < ActiveRecord::Base
  attr_accessible :body, :type_event, :user
  belongs_to :user

  def self.events_for_user_feed(lim = 9)
		types = ['concept_post_revision','concept_post_acceptance','concept_post_rejection',
			'concept_post_to_expert','concept_comment_save', 'concept_post_save',
			'plan_post_revision','plan_post_acceptance','plan_post_rejection',
			'plan_post_to_expert','plan_comment_save', 'plan_post_save','plan_post_update',
		 'life_tape_post_save', 'life_tape_comment_save', 'concept_post_update', 
		 'question_save','news_comment_save','news_post_save','estimate_post_save', 'answer_save']
		Journal.find(:all, :conditions => ["type_event IN (?)", types ], :limit => lim, :order => 'created_at DESC')
	end	
end
