class Frustration < ActiveRecord::Base
  attr_accessible :content, :structure, :archive, :old_content

  belongs_to :user
  belongs_to :negative_user, :class_name => "User", :foreign_key => "negative_user_id"


  validates :content, :presence => true, :length => {:maximum => 800}
  validates :user_id, :presence => true

  has_many :frustration_comments, :dependent => :destroy

  default_scope :order => 'frustrations.created_at DESC'

  def self.feed_all 
  	Frustration.where(:archive => false)
  end

  def self.feed_archive
    Frustration.where(:archive => true)
  end

  def self.feed_structure
  	Frustration.where(:structure => true).where(:archive => false)
  end

  def self.feed_unstructure
  	Frustration.where(:structure => false).where(:archive => false)
  end

  def negative_comments
    FrustrationComment.where(:negative => true)
  end

  
end
