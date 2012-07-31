class Frustration < ActiveRecord::Base
  attr_accessible :content, :structure

  belongs_to :user

  validates :content, :presence => true, :length => {:maximum => 800}
  validates :user_id, :presence => true

  default_scope :order => 'frustrations.created_at DESC'
  
end
