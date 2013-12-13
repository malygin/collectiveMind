# encoding: utf-8
require 'digest'

class User < ActiveRecord::Base
  attr_accessor :password, :secret, :secret2, :secret3
  attr_accessible :login, :nickname, :anonym, :password, :password_confirmation, :encrypted_password, :secret,
   :dateActivation, :dateLastEnter, :dateRegistration, :email, :faculty, :group,
    :name, :string, :string, :surname, :validate, :vkid,
    :score,  :score_a, :score_g, :score_o,
    :admin, :expert

  has_many :question, :dependent => :destroy
  has_many :answer, :dependent => :destroy
  has_many :test_attempts
  has_many :journals
  
  has_and_belongs_to_many :questions
  has_and_belongs_to_many :answers

  has_many :life_tape_comment_voitings
  has_many :life_tape_comments, :through => :life_type_comment_voitings
  has_many :life_tape_posts, :class_name => "LifeTape::Post"
  has_many :discontent_posts, :class_name => "Discontent::Post"

  has_many :essay_posts, :class_name => "Essay::Post"




  has_many :concept_posts, :class_name => "Concept::Post"
  
  has_many :aspect_votings, :class_name => "LifeTape::Voiting"
  has_many :voted_aspects, :through => :aspect_votings, :source => :discontent_aspect, :class_name => "Discontent::Aspect"
  
  has_many :post_votings, :class_name => "Discontent::Voting"
  has_many :voted_discontent_posts, :through => :post_votings, :source => :discontent_post, :class_name => "Discontent::Post"
    
  has_many :concept_post_votings, :class_name => "Concept::Voting"
  has_many :voted_concept_post_aspects, :through => :concept_post_votings, :source => :concept_post_aspect, :class_name => "Concept::PostAspect"

  has_many :plan_post_votings, :class_name => "Plan::Voting"
  has_many :voted_plan_posts, :through => :plan_post_votings, :source => :plan_post, :class_name => "Plan::Post"

  has_many :core_project_users, :class_name => "Core::ProjectUser"
  has_many :projects, :through => :core_project_users, :source => :core_project, :class_name => "Core::Project"
  
  has_many :user_awards
  has_many :awards, :through => :user_awards  
  validates :name,
  				   :length => { :maximum => 50 }


  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  validates :password, :presence => true,
  						:confirmation => true,
  						:length => { :within => 6..40 },
              :on => :create
  validates :password_confirmation, presence: true,
   :length => { :within => 6..40 }, :on => :create
before_save :encrypt_password
  attr_accessible :avatar

  # This method associates the attribute ":avatar" with a file attachment
  has_attached_file :avatar, styles: {
    thumb: '57x74>',
    normal: '300x300>'
  }

  def add_score(score, type=:score_g)
    self.update_column(:score, self.score + score)
    self.update_column(type.to_sym, self.attributes[type.to_s] + score)
  end

  def has_password?(submitted_password)
    # encrypted_password == encrypt(submitted_password)
  	encrypted_password == submitted_password
  end

  def self.authenticate(email, submitted_password)
  	user = find_by_email(email)
    
    #puts user.has_password?(submitted_password)
    if user.nil?
       user = find_by_login(email)
    end
  	return  nil if user.nil?
  	return user if user.has_password?(submitted_password)
  end

  def self.authenticate_with_salt(id, cookie_salt)
  	user = find_by_id(id)
  	(user && user.salt == cookie_salt)? user : nil
  end

  def name_title
    if self.anonym
      self.nickname
    else
      self.name + " "+self.surname
    end
  end

  def role_name
    if self.admin
      "модератор"
    elsif self.expert
      "эксперт"    
    elsif self.jury
      "жюри"
    else 
      ""
    end
  end
  def boss?
    self.admin or self.expert
  end
  def have_essay_for_stage(project, stage)
    # puts self.essay_posts.where(:stage => stage)
    !self.essay_posts.where(:project_id => project, :stage => stage).empty?
  end
      


  private 

  	def encrypt_password
  		self.salt = make_salt if new_record?
  		#self.encrypted_password = encrypt (password)

      self.encrypted_password = password unless password.blank?
  	end

  	# def encrypt(string)
  	# 	secure_hash("#{salt}--#{string}")
  	# end

  	def make_salt
  		secure_hash("#{Time.now.utc}--#{password}")
  	end

  	def secure_hash(string)
  		Digest::SHA2.hexdigest(string)
  	end


end
