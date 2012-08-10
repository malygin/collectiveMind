# encoding: utf-8
class Frustration < ActiveRecord::Base
  attr_accessible :content, :structure, :archive, :old_content, :struct_user

  belongs_to :user
  # user, who negative comment was used for archiving frustration
  belongs_to :negative_user, :class_name => "User", :foreign_key => "negative_user_id"
  # user, who structure comment was used for structuring frustration
  belongs_to :struct_user, :class_name => "User", :foreign_key => "struct_user_id"


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

  def type
    if self.archive 
      return "В архиве"
    elsif self.structure 
      return "Структурирована"
    else 
      return "Неструктурирована"
    end
  end

  
end
