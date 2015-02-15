require 'similar_text'
class Plan::PostAspect < ActiveRecord::Base
  belongs_to :concept_post_aspect, class_name: 'Concept::PostAspect', foreign_key: :concept_post_aspect_id
  belongs_to :plan_post, class_name: 'Plan::Post', foreign_key: :plan_post_id
  belongs_to :discontent, class_name: 'Discontent::Post', foreign_key: :core_aspect_id
  belongs_to :plan_post_stage, class_name: 'Plan::PostStage', foreign_key: :post_stage_id

  has_many :plan_post_resources, class_name: 'Plan::PostResource', foreign_key: :post_id
  has_many :plan_post_actions, -> { order :date_begin }, class_name: 'Plan::PostAction', foreign_key: :plan_post_aspect_id
  has_many :estimate_post_aspects, class_name: 'Estimate::PostAspect', foreign_key: :plan_post_aspect_id
  has_many :plan_notes, class_name: 'Plan::Note', foreign_key: :post_id

  def post_notes(type_field)
    self.plan_notes.by_type(type_field)
  end

  def note_size?(type_fd)
    self.post_notes(type_fd).size > 0
  end

  def estimate_post_aspect(post)
    estimate_post_aspects.where(post_id: post).first
  end

  def duplicate_plan_post_resources(project, post)
    post.plan_post_resources.each do |rs|
      self.plan_post_resources.build(name: rs.name, desc: rs.desc, type_res: rs.type_res, project_id: project.id, style: rs.style).save if rs!=''
    end
  end

  def duplicate_concept_post_resources(project, post)
    post.concept_post_resources.each do |rs|
      self.plan_post_resources.build(name: rs.name, desc: rs.desc, type_res: rs.type_res, project_id: project.id, style: rs.style).save if rs!=''
    end
  end
end
