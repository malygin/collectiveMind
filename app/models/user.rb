# encoding: utf-8
require 'digest'

class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :login, :password, :password_confirmation, :encrypted_password,
   :dateActivation, :dateLastEnter, :dateRegistration, :email, :faculty, :group,
    :name, :string, :string, :surname, :validate, :vkid, :score, :admin, :expert 

  has_many :question, :dependent => :destroy
  has_many :answer, :dependent => :destroy
  has_many :test_attempts
  has_many :journals
  
  has_and_belongs_to_many :questions
  has_and_belongs_to_many :answers

  has_many :life_tape_comment_voitings
  has_many :life_tape_comments, :through => :life_type_comment_voitings
  has_many :life_tape_posts, :class_name => "LifeTape::Post"

  has_many :essay_posts, :class_name => "Essay::Post"




  has_many :concept_posts, :class_name => "Concept::Post"
  
  has_many :aspect_votings, :class_name => "LifeTape::Voiting"
  has_many :voted_aspects, :through => :aspect_voitings, :source => :discontent_aspect, :class_name => "Discontent::Aspect"
  
  has_many :post_votings, :class_name => "Discontent::Voting"
  has_many :voted_discontent_posts, :through => :post_votings, :source => :discontent_post, :class_name => "Discontent::Post"
  
  has_many :user_awards
  has_many :awards, :through => :user_awards  

  validates :name, :presence => true,
  				   :length => { :maximum => 50 }


  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  validates :password, :presence => true,
  						:confirmation => true,
  						:length => { :within => 6..40 }
  validates :password_confirmation, presence: true, :length => { :within => 6..40 }
  before_save :encrypt_password

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
    self.name + " "+self.surname
  end

  def role_name
    if self.admin
      "модератор"
    elsif self.expert
      "эксперт"    
    elsif self.jury
      "жюри"
    else 
      "студент"
    end
  end

  def have_essay_for_stage(stage)
    # puts self.essay_posts.where(:stage => stage)
    !self.essay_posts.where(:stage => stage).empty?
  end
      


  private 

  	def encrypt_password
  		self.salt = make_salt if new_record?
  		#self.encrypted_password = encrypt (password)
      self.encrypted_password = password
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
