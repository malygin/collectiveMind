# encoding: utf-8

class Discontent::Post < ActiveRecord::Base
  include BasePost
  attr_accessible :when, :where, :aspect_id, :replace_id, :aspect
  belongs_to :aspect
  has_many :childs, :class_name => "Discontent::Post", :foreign_key => "replace_id"
  belongs_to :post, :class_name => "Discontent::Post", :foreign_key => "replace_id"

  has_many :voted_users, :through => :final_votings, :source => :user
  has_many :final_votings,:foreign_key => 'discontent_post_id', :class_name => "Discontent::Voting"

  def show_content
  	'<b>что:</b>'+self.content + '<br/> <b> когда:</b>'+ self.when + '<br/> <b>где:</b> ' +self.where
  end
end
