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


  attr_accessible :desc,:postion, :secret, :type_project, :name, :short_desc, :knowledge, :status, :type_access, 
  :url_logo, :stage1, :stage2, :stage3, :stage4, :stage5

  has_many :life_tape_posts, :class_name => "LifeTape::Post", :conditions => ['status = 0']
  has_many :aspects, :class_name => "Discontent::Aspect"

  has_many :discontents, :class_name => "Discontent::Post"
  has_many :discontent_ongoing_post, :conditions =>"status = 0  ", :class_name => "Discontent::Post"
  has_many :discontent_accepted_post, :conditions =>"status = 2  ", :class_name => "Discontent::Post"
  has_many :discontent_for_admin_post, :conditions =>"status = 1  ", :class_name => "Discontent::Post"

  has_many :concept_ongoing_post, :conditions =>"status = 0  ", :class_name => "Concept::Post"
  has_many :concept_accepted_post, :conditions =>"status = 2  ", :class_name => "Concept::Post"
  has_many :concept_for_admin_post, :conditions =>"status = 1  ", :class_name => "Concept::Post"

  has_many :plan_post, :conditions =>"status = 0", :class_name => "Plan::Post"
  has_many :estimate_posts, :conditions =>"status = 1", :class_name => "Estimate::Post"

  has_many :project_users
  has_many :users, :through => :project_users
  has_many :knowbase_posts, :class_name => 'Knowbase::Post'

  LIST_STAGES = {1 => {name: 'Сбор информации', :type_stage => :life_tape_posts, status: [0,1,2]},
         2 => { name: 'Анализ ситуации', :type_stage =>  :discontent_posts, status: [3,4,5,6]},
         3 => { name: 'Формулирование проблемы', :type_stage => :concept_posts, status: [7,8]},
         4 => { name: 'Проекты', :type_stage =>  :plan_posts, status: [9]},
         5 => { name: 'Оценки', :type_stage =>  :estimate_posts, status: [10,11,12,13]}}.freeze


  def get_free_votes_for(user, stage, project)
    case stage
      when :life_tape
        self.stage1.to_i - user.voted_aspects.by_project(project.id).size
      when :discontent
        self.stage2.to_i - user.voted_discontent_posts.count

    end
  end
  def get_united_posts_for_vote(project, user)
    voted = user.voted_discontent_posts.pluck(:id)
    Discontent::Post.united_for_vote(project.id,voted)
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
  def  status_title(status = self.status)
    case status
      when 0
        'подготовка к процедуре'
      when 1, :life_tape_posts
        I18n.t('stages.life_tape')
      when 2
        'голосование за аспекты и рефлексия'
      when 3, :discontent_posts
        I18n.t('stages.discontent')
      when 4
        'голосование за недовольства и рефлексия'
      when 7, :concept_posts
        I18n.t('stages.concept')
      when 8
        'голосование за концепции и рефлексия'
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
end
