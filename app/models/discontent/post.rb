# encoding: utf-8

class Discontent::Post < ActiveRecord::Base
  include BasePost
  attr_accessible :whend, :whered, :aspect_id, :replace_id, :aspect, :style
  belongs_to :aspect
  has_many :childs, :class_name => 'Discontent::Post', :foreign_key => 'replace_id'
  belongs_to :post, :class_name => 'Discontent::Post', :foreign_key => 'replace_id'
  has_many :concept_conditions, :class_name => 'Concept::PostAspect', :foreign_key => 'discontent_aspect_id'
  has_many :plan_conditions, :class_name => 'Plan::PostAspect', :foreign_key => 'discontent_aspect_id'

  has_many :concept_posts, :through => :concept_conditions, :foreign_key => 'concept_post_id', :class_name => "Concept::Post"
  has_many :post_replaces, :class_name => 'Discontent::PostReplace', :foreign_key => 'post_id'
  has_many :post_it_replaces, :class_name => 'Discontent::PostReplace', :foreign_key => 'replace_id'

  has_many :post_replaced, :through => :post_replaces, :source => :replace_post, :class_name =>  'Discontent::Post'

  has_many :post_replaced_it, :through => :post_it_replaces, :source => :replace_post, :class_name =>  'Discontent::Post'

  has_many :voted_users, :through => :final_votings, :source => :user
  has_many :final_votings,:foreign_key => 'discontent_post_id', :class_name => 'Discontent::Voting'
  #scope :ready_for_post, lambda {  where(:status => 0).where("created_at < ?", 2.day.ago) }
  #scope :not_ready_for_post, lambda {  where(:status => 0).where("created_at > ?", 2.day.ago) }



  def voted(user)
    self.voted_users.where(:id => user)
  end

  def conditions_for_plan(plan)
    plan_conditions.where(:plan_post_id => plan)
  end

  def pure_conditions()
    concept_conditions.where("concept_post_id IS NOT NULL")
  end

  def show_content
  	'<b>что: </b>'+self.content + '<br/> <b> когда: </b>'+ self.when + '<br/> <b>где: </b> ' +self.where+'<br/>'
  end

  def not_vote_for_other_post_aspects(user)
    self.concept_conditions.each  do |asp|
      if asp.voted(user).size>0
        return false
      end
    end
    return true
  end

end
