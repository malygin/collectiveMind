class ExpertNews::Post < ActiveRecord::Base
  attr_accessible :anons, :content, :title, :user
  has_many :comments

  belongs_to :user
  default_scope :order => 'expert_news_posts.created_at DESC'
end
