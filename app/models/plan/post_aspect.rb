# encoding: utf-8
require 'similar_text'
class Plan::PostAspect  < ActiveRecord::Base
  attr_accessible :discontent_aspect_id, :plan_post_id, :content, :control,
                  :name, :negative, :positive, :reality, :problems, :first_stage,
                  :concept_post_aspect_id, :obstacles, :negative_r,
                  :positive_r, :negative_s, :positive_s,:control_r, :control_s,:title

  belongs_to :concept_post_aspect, :class_name => 'Concept::PostAspect', :foreign_key => :concept_post_aspect_id
  belongs_to :plan_post, :class_name => 'Plan::Post', :foreign_key => :plan_post_id
  belongs_to :discontent, :class_name => 'Discontent::Post', :foreign_key => :discontent_aspect_id
  has_many :plan_post_first_conds, :class_name => 'Plan::PostFirstCond'
  has_many :plan_post_resources, :class_name => 'Plan::PostResource', :foreign_key => :post_id

  def compare_text
    unless self.concept_post_aspect.nil?
      score = ((self.content.similar(self.concept_post_aspect.content) +
          self.positive.similar(self.concept_post_aspect.positive) +
          self.negative.similar(self.concept_post_aspect.negative) +
          self.reality.similar(self.concept_post_aspect.reality) +
          self.problems.similar(self.concept_post_aspect.problems)) /5).round(1)
      if score.nan?
        nil
      elsif score ==100
        "(идентично предыдущей стадии)"
      elsif score > 90
        "(небольшие изменения = #{score}%)"

      elsif score >70
        "(существенные  изменения = #{score}%)"

      elsif score > 40
        "(сильно переработано = #{score}%)"
      else
        "(сильно переработано = #{score}%)"
      end
    else
      "(новое)"
    end

  end

end
