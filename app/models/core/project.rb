# encoding: utf-8

class Core::Project < ActiveRecord::Base
##### status 
# 0 - prepare to procedure
# 1 - life_tape
# 2 - vote fo aspects
# 3 - Discontent
# 4 - voting for Discontent
# 5 - Concept 
# 6 - voiting for Concept
# 7 - plan
# 8 - voiting for plan
# 9 - estimate
# 10 - final vote
# 11 - wait for decision
# 20  - complete
####### type_access
# 0 open for everyone and everyone may be participant
# 1 open for everyone but participant may be only with rights
# 2  closed, only for participant
####### type_project
# 0 normal
# 1 invisible
####### new type_access
# 0 opened for all
# 1 only for ratio club and all moderators
# 2 closed, only for invited and prime moderators
# 3 demo (opened for all)
# 4 testing
# 5 preparing procedure
# 10 disabled

  attr_accessible :desc,:postion, :secret, :type_project, :name, :short_desc, :knowledge, :status, :type_access, 
  :url_logo, :stage1, :stage2, :stage3, :stage4, :stage5

  has_many :life_tape_posts, :class_name => "LifeTape::Post", :conditions => ['status = 0']
  has_many :aspects, :class_name => "Discontent::Aspect"

  has_many :discontents, :class_name => "Discontent::Post"
  has_many :discontent_ongoing_post, :conditions =>"status = 0  ", :class_name => "Discontent::Post"
  has_many :discontent_accepted_post, :conditions =>"status = 2  ", :class_name => "Discontent::Post"
  has_many :discontent_for_admin_post, :conditions =>"status = 1  ", :class_name => "Discontent::Post"

  has_many :concepts, :class_name => "Concept::Post"
  has_many :concept_ongoing_post, :conditions =>"status = 0  ", :class_name => "Concept::Post"
  has_many :concept_accepted_post, :conditions =>"status = 2  ", :class_name => "Concept::Post"
  has_many :concept_for_admin_post, :conditions =>"status = 1  ", :class_name => "Concept::Post"

  has_many :plan_post, :conditions =>"status = 0", :class_name => "Plan::Post"
  has_many :estimate_posts, :conditions =>"status = 0", :class_name => "Estimate::Post"

  has_many :project_users
  has_many :users, :through => :project_users
  has_many :knowbase_posts, :class_name => 'Knowbase::Post'

  has_many :core_project_scores, :class_name => 'Core::ProjectScore'

  has_many :core_project_users, :class_name => 'Core::ProjectUser'
  has_many :users_in_project, :through => :core_project_users, :source => :user, :class_name => "User"

  has_many :essays, :class_name => 'Essay::Post', :conditions => ['status = 0']
  #has_many :project_score_users, :class_name => 'User', :through => :core_project_scores, :source => :user

  LIST_STAGES = {1 => {name: 'Подготовка к процедуре', :type_stage => :life_tape_posts, status: [0,1,2,20]},
         2 => { name: 'Сбор несовершенств', :type_stage =>  :discontent_posts, status: [3,4,5,6]},
         3 => { name: 'Сбор нововведений', :type_stage => :concept_posts, status: [7,8]},
         4 => { name: 'Создание проектов', :type_stage =>  :plan_posts, status: [9]},
         5 => { name: 'Выставление оценок', :type_stage =>  :estimate_posts, status: [10,11,12,13]}}.freeze


  def get_free_votes_for(user, stage, project)
    case stage
      when 'lifetape'
        self.stage1.to_i - user.voted_aspects.by_project(project.id).size
      when 'discontent'
        self.stage2.to_i - user.voted_discontent_posts.by_project(project.id).size
      when 'plan'
        self.stage5.to_i - user.voted_plan_posts.by_project(project.id).size
    end
  end

  def project_access(user)
    type_project = self.type_access
    type_user = user.type_user

    if [1,7].include?(type_user) and [0,1,2,3,4,5].include?(type_project)
      true
    elsif [6].include?(type_user) and [0,1,3,4,5].include?(type_project)
      true
    elsif [2,3].include?(type_user) and [0,1,3].include?(type_project)
      true
    elsif [4,5].include?(type_user) and [0,1,3].include?(type_project)
      true
    elsif [8].include?(type_user) and [0,3].include?(type_project)
      true
    elsif [0,3].include?(type_project)
      true
    elsif [2].include?(type_project) and user.projects.include?(self)
      true
    else
      false
    end
  end

  def type_access_name
    type_project = self.type_access

    case type_project
      when 0
        'Открытая'
      when 1
        'Для клубистов'
      when 2
        'Закрытая'
      when 3
        'Демо'
      when 4
        'Тестовая'
      when 5
        'Подготовка'
      else
        'Не задано'
    end
  end

  def proc_aspects
    self.aspects.where(status:0)
  end
  def get_united_posts_for_vote( user)
    voted = user.voted_discontent_posts.pluck(:id)
    Discontent::Post.united_for_vote(self.id,voted)
  end
  def get_concept_posts_for_vote(user)
    voted = user.concept_post_votings.pluck(:id)
    Concept::Post.united_for_vote(self.id,voted)
  end


  def current_status?( status)
    sort_list  = LIST_STAGES.select {|k,v| v[:type_stage]  == status}
    sort_list.values[0][:status].include? self.status
  end

  def stage_style(status)
     return 'disabled' if self.status < status_number(status)
     return 'active' if current_status?(status)
  end

  def stage_style_link(name_page, status)
     return 'disabled' if self.status < status_number(status)
     return 'current' if current_page?(name_page, status)
  end


  def current_page?(page, status)
    sort_list  = LIST_STAGES.select {|k,v| v[:type_stage]  == status}
    sort_list.values[0][:name] == page

  end

  def redirect_to_current_stage
    sort_list  = LIST_STAGES.select {|k,v| v[:status].include? self.status}
    sort_list.values[0][:type_stage]
  end

  def can_edit_on_current_stage(p)
    if p.instance_of? LifeTape::Post
        return true
     elsif p.instance_of? Discontent::Post
       return self.status == 3
     elsif p.instance_of? Concept::Post
       return self.status == 7
     elsif p.instance_of? Plan::Post
       return self.status == 9
     elsif p.instance_of? Estimate::Post
       return self.status == 10
     end
    return false
  end

  def status_number(status)
    case status
      when :life_tape_posts
        1
      when :discontent_posts
        3
      when :concept_posts
        7
      when :plan_posts
        9
      when :estimate_posts
        10
     end
  end

  def demo?
    self.type_access == 3
  end

  def  status_title(status = self.status)
    case status
      when 0
        'подготовка к процедуре'
      when 1, :life_tape_posts
        I18n.t('stages.life_tape')
      when 2
        'голосование за темы и рефлексия'
      when 3, :discontent_posts
        I18n.t('stages.discontent')
      when 4
        'группировка несовершенств'
      when 5
        'обсуждение сгруппированных несовершенств'
      when 6
        'голосование за несовершенства и рефлексия'
      when 7, :concept_posts
        I18n.t('stages.concept')
      when 8
        'голосование за нововведения и рефлексия'
      when 9, :plan_posts
        'Создание проектов'
      when 10, :estimate_posts
        'Выставление оценок'
      when 11
        'голосование за проекты'
      when 12
        'подведение итогов'
      else
        'завершена'
    end
  end

  def essay_count(stage)
    self.essays.by_stage(stage)
  end

  def problems_comments_for_improve
    life_tape_comments = LifeTape::Comment.joins("INNER JOIN life_tape_posts ON life_tape_comments.post_id = life_tape_posts.id").
        where("life_tape_posts.project_id = ? and life_tape_comments.discontent_status = 't'", self.id)
    discontent_comments = Discontent::Comment.joins("INNER JOIN discontent_posts ON discontent_comments.post_id = discontent_posts.id").
        where("discontent_posts.project_id = ? and discontent_comments.discontent_status = 't'", self.id)
    comments_all = life_tape_comments | discontent_comments
    comments_all.sort_by{|c| c.improve_disposts.size}
  end

  def ideas_comments_for_improve
    life_tape_comments = LifeTape::Comment.joins("INNER JOIN life_tape_posts ON life_tape_comments.post_id = life_tape_posts.id").
        where("life_tape_posts.project_id = ? and life_tape_comments.concept_status = 't'", self.id)
    discontent_comments = Discontent::Comment.joins("INNER JOIN discontent_posts ON discontent_comments.post_id = discontent_posts.id").
        where("discontent_posts.project_id = ? and discontent_comments.concept_status = 't'", self.id)
    concept_comments = Concept::Comment.joins("INNER JOIN concept_posts ON concept_comments.post_id = concept_posts.id").
        where("concept_posts.project_id = ? and concept_comments.concept_status = 't'", self.id)
    comments_all = life_tape_comments | discontent_comments | concept_comments
    comments_all.sort_by{|c| c.improve_concepts.size}
  end


end
