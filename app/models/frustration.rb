class Frustration < ActiveRecord::Base
  attr_accessible :content, :structure

  belongs_to :user

  validates :content, :presence => true, :length => {:maximum => 800}
  validates :user_id, :presence => true

  has_many :comment_frustrations, :dependent => :destroy

  default_scope :order => 'frustrations.created_at DESC'

  def self.feed_all 
  	Frustration.all
  end

  def self.feed_structure
  	Frustration.where(:structure => true)

  end

  def self.feed_unstructure
  	Frustration.where(:structure => false)
  end

  
end
