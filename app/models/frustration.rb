# encoding: utf-8
class Frustration < ActiveRecord::Base
  #status 0 -unstructed, 1 -archive, 2 - structed, 3 -to expert, 
  #4 -allow expert, 5 -deny expert
  attr_accessible  :status, :struct_user,:structuring_date, :trash, 
  :what, :wherin, :when, :what_old, :wherin_old, :when_old, :what_expert, :wherin_expert, 
  :when_expert, :content_text, :content_text_old, :frustration_useful_comments


  belongs_to :user
  # user, who negative comment was used for archiving frustration
  belongs_to :negative_user, :class_name => "User", :foreign_key => "negative_user_id"
  # user, who structure comment was used for structuring frustration
  belongs_to :struct_user, :class_name => "User", :foreign_key => "struct_user_id"
  belongs_to :project

  validates :what, :length => {:maximum => 300}
  validates :wherin, :length => {:maximum => 300}
  validates :when, :length => {:maximum => 300}
  validates :user_id, :presence => true

  has_many :frustration_comments, :dependent => :destroy
  has_many :frustration_useful_comments, :class_name =>'FrustrationComment',
  :foreign_key => 'useful_frustration_id',  :dependent => :destroy

  default_scope :order => 'frustrations.created_at DESC'


  def self.feed_all 
  	Frustration.all
  end

  def self.feed_archive
    Frustration.where(:status => 1)
  end

  def self.feed_structure
  	Frustration.where(:status => 2)
  end

  def self.feed_unstructure
  	Frustration.where(:status => 0)
  end

  def self.feed_to_expert
    Frustration.where(:status => 3)
  end

  def self.feed_accepted
    Frustration.where(:status => 4)
  end

  def self.feed_declined
    Frustration.where(:status => 5)
  end

  def negative
    self.frustration_comments.where(:negative => true).where(:trash => false)
  end

  def structure
    self.frustration_comments.where(:negative => false).where(:trash => false)
  end

  def comments_before_structuring
    if self.structuring_date.nil?
      return self.frustration_comments.where(:trash => false).where('frustration_comment_id' => nil)
    else
      self.frustration_comments.where('created_at < ?', self.structuring_date).where(:trash => false).where('frustration_comment_id' => nil)
    end
  end

  def comments_after_structuring
    self.frustration_comments.where('created_at > ?', self.structuring_date).where(:trash => false).where('frustration_comment_id' => nil)
  end


  def archive?
    self.status == 1
  end

  def accepted? 
    self.status == 4
  end
  
  def structured?
    self.status ==2
  end
  
  def content
    if not self.what_expert.nil?
     'что: '+ self.what_expert + "; когда: " + self.wherin_expert + "; где: " + self.when_expert
    elsif not self.what.nil?
      'что: '+self.what + "; когда: " +self.when + "; где: " + self.wherin
    else
      self.content_text
    end
  end

  def old_content
    if not self.content_text_old.nil?
      return self.content_text_old
    elsif self.what_old.nil?
      return nil
    else   
      'что: '+self.what_old + "; когда: " +self.when_old + "; где: " + self.wherin_old
    end
  end
  def content_before_expert 
    'что: '+self.what + "; когда: " +self.when + "; где: " + self.wherin
  end

  def expert_content
    unless self.what_expert.nil?
      self.what_expert + " " + self.wherin_expert + " " + self.when_expert
    end
  end




  def type
    case self.status
      when 0
        return "Произвольное"
      when 1
        return "В архиве"
      when 2
        return "Оформленое"
      when 3 
        return "На рассмотрении эксперта"
      when 4 
        return "Принята экспертом"
      when 5
        return "Отклонена экспертом"
    end
  end

  
end
