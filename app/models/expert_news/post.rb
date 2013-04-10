class ExpertNews::Post < ActiveRecord::Base
  include BasePost

  attr_accessible :anons,:title
  default_scope :order => 'expert_news_posts.created_at DESC'
end
