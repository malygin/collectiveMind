# encoding: utf-8

class Discontent::Post < ActiveRecord::Base
  include BasePost
  attr_accessible :when, :where, :aspect_id, :replace_id, :aspect, :style
  belongs_to :aspect
  has_many :childs, :class_name => 'Discontent::Post', :foreign_key => 'replace_id'
  belongs_to :post, :class_name => 'Discontent::Post', :foreign_key => 'replace_id'
  has_many :concept_conditions, :class_name => 'Concept::PostAspect', :foreign_key => 'discontent_aspect_id'
  has_many :concept_posts, :through => :concept_conditions, :foreign_key => 'concept_post_id', :class_name => "Concept::Post"
  has_many :post_replaces, :class_name => 'Discontent::PostReplace', :foreign_key => 'post_id'
  has_many :post_it_replaces, :class_name => 'Discontent::PostReplace', :foreign_key => 'replace_id'

  has_many :post_replaced, :through => :post_replaces, :source => :replace_post, :class_name =>  'Discontent::Post'

  has_many :post_replaced_it, :through => :post_it_replaces, :source => :replace_post, :class_name =>  'Discontent::Post'

  has_many :voted_users, :through => :final_votings, :source => :user
  has_many :final_votings,:foreign_key => 'discontent_post_id', :class_name => 'Discontent::Voting'
  scope :ready_for_post, lambda {  where(:status => 0).where("created_at < ?", 2.day.ago) }
  scope :not_ready_for_post, lambda {  where(:status => 0).where("created_at > ?", 2.day.ago) }
    def voted(user)
    self.voted_users.where(:id => user)
  end

  def show_content
  	'<b>что:</b>'+self.content + '<br/> <b> когда:</b>'+ self.when + '<br/> <b>где:</b> ' +self.where+'<br/>'

  end
end
