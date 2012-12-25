# encoding: utf-8
require 'digest'

class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :login, :password, :password_confirmation, :encrypted_password,
   :dateActivation, :dateLastEnter, :dateRegistration, :email, :faculty, :group,
    :name, :string, :string, :surname, :validate, :vkid, :score

  has_many :frustrations, :dependent => :destroy
  has_many :frustration_comments, :dependent => :destroy

  has_many :question, :dependent => :destroy
  has_many :answer, :dependent => :destroy
  has_many :test_attempts
  has_many :journals
  
  has_and_belongs_to_many :questions
  has_and_belongs_to_many :answers

  has_many :life_tape_comment_voitings
  has_many :life_tape_comments, :through => :life_type_comment_voitings

# list of frustrations which was denied for user's comment
  has_many :negatived_frustrations, :class_name => "Frustration", :foreign_key =>"negative_user_id"
  has_many :structured_frustrations, :class_name => "Frustration", :foreign_key =>"struct_user_id"

  has_many :voitings
  has_many :voited_frustrations, :class_name =>'Frustration', :through => :voitings

  has_many :life_tape_posts, :class_name => "LifeTape::Post"
  has_many :concept_posts, :class_name => "Concept::Post"

  has_many :user_awards
  has_many :awards, :through => :user_awards


  has_many :frustration_forecasts
  has_many :forecasts , :class_name => 'Frustration', :through => :frustration_forecasts

  has_many :concept_forecasts, :class_name => 'Concept::Forecast'
  has_many :forecast_tasks, :class_name => 'Concept::ForecastTask', :through => :concept_forecasts
  has_one :frustration_essay
  has_one :concept_essay, :class_name => 'Concept::Essay'

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, :presence => true,
  				   :length => { :maximum => 50 }
  validates :email, :format => { :with => email_regex }
  validates :password, :presence => true,
  						:confirmation => true,
  						:length => { :within => 3..40 }

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
    else 
      "студент"
    end
  end


 
      


  def self.only_simple_users
    User.where(:admin => false).where(:expert => false)
  end

  def structured_and_unstructured
    self.frustrations.where(:status => [0,2])
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
