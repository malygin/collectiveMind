class Plan::PostStage < ActiveRecord::Base
  attr_accessible :date_begin, :date_end, :desc, :name, :post, :status
  belongs_to :post, :class_name => 'Plan::Post'
  has_many :plan_post_aspects, :class_name => 'Plan::PostAspect', :foreign_key => :post_stage_id

  def actions_rowcount
    self.plan_post_aspects.
    joins('INNER JOIN "plan_post_actions" ON "plan_post_aspects"."id" = "plan_post_actions"."plan_post_aspect_id"')
  end

end
