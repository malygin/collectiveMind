class Award < ActiveRecord::Base
  attr_accessible :desc, :name, :url, :position
  has_many :user_awards
  has_many :users, :through => :user_awards
  scope :for_project, lambda  {|project| where('user_awards.project_id' => project) }

end
