# encoding: utf-8
require 'digest/sha1'

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,:lastseenable
  # Setup accessible (or protected) attributes for your model
  attr_accessible  :remember_me, :password, :password_confirmation

  attr_accessor  :secret, :secret2, :secret3

  attr_accessible :login, :nickname, :anonym,  :secret,
   :dateActivation, :dateLastEnter, :dateRegistration, :email, :faculty, :group,
    :name, :string, :string, :surname, :validate, :vkid,
    :score,  :score_a, :score_g, :score_o,
    :admin, :expert

  scope :scope_score_name, ->(sn) { where("#{sn}>0").order("#{sn} DESC") }
  #has_many :help_questions, :class_name => 'Help::Question'
  #has_many :help_answers, :class_name => 'Help::Answer'
  has_many :help_users_answerses, :class_name => 'Help::UsersAnswers'
  has_many :help_answers, :class_name => 'Help::Answer', :through => :help_users_answerses
  has_many :help_questions, :class_name => 'Help::Question', :through => :help_answers
  has_many :help_posts, :class_name => 'Help::Post', :through => :help_questions, :source => :post

  has_many :journals
  
  has_and_belongs_to_many :questions
  has_and_belongs_to_many :answers

  has_many :life_tape_comment_voitings
  has_many :life_tape_comments, :through => :life_type_comment_voitings
  has_many :life_tape_posts, :class_name => "LifeTape::Post"
  has_many :discontent_posts, :class_name => "Discontent::Post"

  has_many :discontent_aspect_users, :class_name => 'Discontent::AspectUser'
  has_many :discontent_aspects, :class_name => 'Discontent::Aspect', :through => :discontent_aspect_users

  has_many :essay_posts, :class_name => "Essay::Post"

  has_many :life_tape_post_discussions, :class_name => 'LifeTape::PostDiscussion'
  has_many :user_discussion_posts, :through => :life_tape_post_discussions, :source => :post, :class_name => 'LifeTape::Post'
  has_many :user_discussion_aspects, :through => :life_tape_post_discussions, :source => :aspect, :class_name => 'Discontent::Aspect'

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

  #before_save :encrypt_password
  attr_accessible :avatar

  # This method associates the attribute ":avatar" with a file attachment
  has_attached_file :avatar, styles: {
    thumb: '57x74>',
    normal: '250x295>'
  }
  def valid_password?(password)
    begin
      super(password)
    rescue BCrypt::Errors::InvalidHash
      return false unless password == encrypted_password
      logger.info "User #{email} is using the old password hashing method, updating attribute."
      self.password = password
      true
    end
  end

  #def add_score(score, type=:score_g)
  #  self.update_column(:score, self.score + score)
  #  self.update_column(type.to_sym, self.attributes[type.to_s] + score)
  #end

  def answered_for_help_stage?(stage)
    self.help_posts.pluck(:stage).include? stage

  end

  def to_s
    if self.anonym
      self.nickname
    else
      "#{self.name} #{self.surname}"
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

  def aspects(id)
    if self.discontent_aspects.empty?
      Discontent::Aspect.where(project_id: id)
    else
      self.discontent_aspects
    end
  end

  def add_score(h={})
    case h[:type]
      when :add_life_tape_post
        self.add_score_by_type(10, :score_g)
      when :plus_comment
        self.add_score_by_type(5, :score_a)
        self.journals.build(:type_event=>'useful_comment', :project => h[:project], :body=>"#{h[:comment].content[0..24]}:#{h[:path]}/#{h[:comment].post.id}#comment_#{h[:comment].id}").save!
        self.journals.build(:type_event=>'my_add_score_comment', :project => h[:project], :user_informed => self, :body=>"5:#{h[:path]}/#{h[:comment].post.id}#comment_#{h[:comment].id}", :viewed=> false).save!

      when :plus_post

        self.add_score_by_type(300, :score_g)  if h[:post].instance_of? Concept::Post
        self.add_score_by_type(30, :score_g)  if h[:post].instance_of? Discontent::Post
        self.add_score_by_type(10, :score_g)  if h[:post].instance_of? LifeTape::Post

        self.journals.build(:type_event=>'useful_post', :project => h[:project], :body=>"#{h[:post].content[0..24]}:#{h[:path]}/#{h[:post].id}").save!

      when :to_archive_life_tape_post
        self.add_score_by_type(-10, :score_g)
      when :add_discontent_post
        if h[:object].whend? and h[:object].whered? and h[:object].style?
          self.add_score_by_type(30, :score_g)
        elsif  h[:object].whend? and h[:object].whered?
          self.add_score_by_type(20, :score_g)
        else
          self.add_score_by_type(10, :score_g)
        end
    end

  end

  def add_score_by_type(score, type = :score_g)
    self.update_attributes!(:score => score+self.score, type => self.read_attribute(type)+score)
  end
  private

  	#def encrypt_password
  	#	self.salt = make_salt if new_record?
  	#	#self.encrypted_password = encrypt (password)
    #
     # self.encrypted_password = password unless password.blank?
  	#end
    #
  	## def encrypt(string)
  	## 	secure_hash("#{salt}--#{string}")
  	## end
    #
  	#def make_salt
  	#	secure_hash("#{Time.now.utc}--#{password}")
  	#end
    #
  	#def secure_hash(string)
  	#	Digest::SHA2.hexdigest(string)
  	#end



end
