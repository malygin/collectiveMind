require 'digest'

class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :login, :password, :password_confirmation, :encrypted_password,
   :dateActivation, :dateLastEnter, :dateRegistration, :email, :faculty, :group,
    :name, :string, :string, :surname, :validate, :vkid

  has_many :frustrations, :dependent => :destroy

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, :presence => true,
  				   :length => { :maximum => 50 }
  validates :email, :format => { :with => email_regex }
  validates :password, :presence => true,
  						:confirmation => true,
  						:length => { :within => 6..40 }

  before_save :encrypt_password

  def has_password?(submitted_password)
  	encrypted_password == encrypt(submitted_password)
  end

  def self.authenticate(email, submitted_password)
  	user = find_by_email(email)
  	#puts email, user.encrypted_password
  	#puts submitted_password, encrypt(submitted_password)
  	return  nil if user.nil?
  	return user if user.has_password?(submitted_password)
  end

  def self.authenticate_with_salt(id, cookie_salt)
  	user = find_by_id(id)
  	(user && user.salt == cookie_salt)? user : nil
  end

  # def name_title
  #   self.name + " "+self.surname
  # end

  private 

  	def encrypt_password
  		self.salt = make_salt if new_record?
  		self.encrypted_password = encrypt (password)
  	end

  	def encrypt(string)
  		secure_hash("#{salt}--#{string}")
  	end

  	def make_salt
  		secure_hash("#{Time.now.utc}--#{password}")
  	end

  	def secure_hash(string)
  		Digest::SHA2.hexdigest(string)
  	end


end
