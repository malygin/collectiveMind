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

  has_many :life_tape_posts, :class_name => "LifeTape::Post"
  has_many :aspects, :class_name => "Discontent::Aspect"

  has_many :discontents, :class_name => "Discontent::Post"
  has_many :discontent_ongoing_post, :conditions =>"status = 0  ", :class_name => "Discontent::Post"
  has_many :discontent_accepted_post, :conditions =>"status = 2  ", :class_name => "Discontent::Post"
  has_many :discontent_for_admin_post, :conditions =>"status = 1  ", :class_name => "Discontent::Post"

  has_many :concept_ongoing_post, :conditions =>"status = 0  ", :class_name => "Concept::Post"
  has_many :concept_accepted_post, :conditions =>"status = 2  ", :class_name => "Concept::Post"
  has_many :concept_for_admin_post, :conditions =>"status = 1  ", :class_name => "Concept::Post"

  has_many :project_users
  has_many :users, :through => :project_users

  LIST_STAGES = {1 => {name: 'Сбор информации', :type_stage => :life_tape_posts, status: [0,1,2]},
         2 => { name: 'Анализ проблемы', :type_stage =>  :discontent_posts, status: [3,4]},
         3 => { name: 'Формулирование проблемы', :type_stage => :concept_posts, status: [5,6]},
         4 => { name: 'Проекты', :type_stage =>  :plan_posts, status: [7,8]},
         5 => { name: 'Оценивание', :type_stage =>  :estimate_posts, status: [9,10]}}.freeze


  def get_free_votes_for(user, stage)
    self.stage1.to_i - user.voted_aspects.size
  end

  def current_status?( status)
    sort_list  = LIST_STAGES.select {|k,v| v[:type_stage]  == status}
    sort_list.values[0][:status].include? self.status
  end

  def redirect_to_current_stage
    sort_list  = LIST_STAGES.select {|k,v| v[:status].include? self.status}
    sort_list.values[0][:type_stage]
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
      when 5
        'формулирование образов'
      when 6
        'голосование за концепции и рефлексия'
      when 7
        'создание проектов'
      when 8
        'выставление оценок'
      when 9
        'голосование за проекты'
      when 10
        'подведение итогов'
      else
        'завершена'
    end
  end
end
