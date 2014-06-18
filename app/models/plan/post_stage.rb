class Plan::PostStage < ActiveRecord::Base
  attr_accessible :date_begin, :date_end, :desc, :name, :post, :status
  belongs_to :post, :class_name => 'Plan::Post'
  has_many :plan_post_aspects, :class_name => 'Plan::PostAspect', :foreign_key => :post_stage_id

  def actions_rowcount
    self.plan_post_aspects.
    joins('INNER JOIN "plan_post_actions" ON "plan_post_aspects"."id" = "plan_post_actions"."plan_post_aspect_id"')
  end


  #def self.scope_vote_top(post)
  #  joins(:concept_post_discontents).
  #      where('"concept_post_discontents"."discontent_post_id" = ?', post.id).
  #      joins(:post_aspects).
  #      joins('INNER JOIN "concept_votings" ON "concept_votings"."concept_post_aspect_id" = "concept_post_aspects"."id"').
  #      where('"concept_votings"."discontent_post_id" = "concept_post_aspects"."discontent_aspect_id"')
  #  .group('"concept_posts"."id"')
  #  .order('count("concept_votings"."user_id") DESC')
  #end

end
