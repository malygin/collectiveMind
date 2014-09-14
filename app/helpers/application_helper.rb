# encoding: utf-8

module ApplicationHelper
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
# 11 - wait for

  def escape_text(t)
    t.gsub("\n", "\\n").gsub("\r", "\\r").gsub("\t", "\\t").gsub("'","\\'")
  end

  def trim_content(s, l=100)
    if s
      s[0..l]
    end
  end

  def class_post_content(pro, ag)
    if  pro > 0
      'label-success'
    elsif ag > 0
      'label-danger'
    else
       'label-g'
    end

  end

  def display_content(content, default_string='---')
    if  not content.nil? and content != ''
      simple_format(content)
    else
      content_tag(:b, default_string)
    end
  end

	def menu_status(st)
		if request.fullpath.include? "status/#{st}" 
			'current'
		end
	end
	
	def cp( stage)
		if stage =='life_tape' and ( [0,1,2].include? @project.status)
			'current'
  		elsif stage == 'discontent' and ([3,4].include? @project.status)
  			'current'  		
  		elsif stage == 'concept' and ([5,6].include? @project.status)
  			'current'
  		elsif stage == 'plan' and (@project.status == 7)
  			'current' 		
  		elsif stage == 'estimate' and ([8,9,10].include? @project.status )
  			'current'
  		end
	end

	def stage_vote?(stage)
		if stage =='life_tape' and (@project.status==2)
			true
		elsif stage =='discontent' and (@project.status==6)
			true
		elsif stage =='concept' and (@project.status==8)
			true	
		elsif stage =='plan' and (@project.status==11)
			true
		else
			false
		end 		
	end

	def image_for_stages(image,  stage)
		if stage =='life_tape' and ([0,1,2].include? @project.status)    
		    return image+'green.png'  
		 elsif stage == 'discontent' and ([3,4].include? @project.status)
		    return image+'green.png' 		 
		elsif stage == 'concept' and ([5,6].include? @project.status)
		    return image+'green.png'  
		elsif stage == 'plan' and (@project.status == 7)
		    return image+'green.png'  		
		elsif stage == 'estimate' and (@project.status == 8)
		    return image+'green.png'  
		else
		  return  image+'.png' 
		end
	end
	def  type_title(pr)
		case pr
			when 0
				'открыта с возможностью участвовать'
			when 1
				'открыта для просмотра'
			when 2
				'закрыта'
			else
				'закрыта'
		end 
	end

	def  type_project(pr)
		case pr
			when 0
				''
			when 1
				'(демонстрационная)'
		end 
	end


	def count_available_voiting(n)
		5-n
	end

	def can_vote?(this_v, all_v, all)
		this_v<1 and all_v!=0
  end

	def can_vote_cond?(this_v, all_v, all, dis)
		this_v<1 and all_v!=0  and dis.not_vote_for_other_post_aspects(current_user)
  end

  def discontent_style_name(dis)
    case dis
      when 0
        content_tag :span,'Отсутствующие достоинства', class: 'label label-p'
      when 1
        content_tag :span, 'Имеющиеся недостатки', class: 'label label-n'
      else
        'не определена'
    end
  end

  def column_for_type_field(table_name, type_field)
    if table_name == 'discontent_note'
      case type_field
        when 1
          'status_content'
        when 2
          'status_whered'
        when 3
          'status_whend'
        else
          ''
      end
    elsif table_name == 'concept_note'
      case type_field
        when 1
          'status_name'
        when 2
          'status_content'
        when 3
          'status_positive'
        when 4
          'status_positive_r'
        when 5
          'status_negative'
        when 6
          'status_negative_r'
        when 7
          'status_control'
        when 8
          'status_control_r'
        when 9
          'status_obstacles'
        when 10
          'status_problems'
        when 11
          'status_reality'
        else
          null
      end
    end
  end

  def column_for_concept_type(type_fd)
    case type_fd
      when 1
        'status_name'
      when 2
        'status_content'
      when 3
        'status_positive'
      when 4
        'status_positive_r'
      when 5
        'status_negative'
      when 6
        'status_negative_r'
      when 7
        'status_control'
      when 8
        'status_control_r'
      when 9
        'status_obstacles'
      when 10
        'status_problems'
      when 11
        'status_reality'
      else
        null
    end
  end
  def fast_discussion_able?
    user_discussion_aspects = current_user.user_discussion_aspects.where(:project_id => @project).size
    if user_discussion_aspects == @project.aspects.size
      return false
    end
    true
  end

  def get_check_field?(field)
    check = current_user.user_checks.where(project_id: @project.id, status: 't', check_field: field).first unless current_user.user_checks.empty?
    if check
      return true
    end
    false
  end

  def get_session_to_work?(value)
    check = current_user.user_checks.where(project_id: @project.id, status: true, check_field: 'session_id', value: value).first unless current_user.user_checks.empty?
    if check
      return true if check.updated_at > 6.hours.ago
    end
    false
  end

  def rowspan_stage(stage)
    2 + stage.plan_post_aspects.size + stage.actions_rowcount.size + (stage.plan_post_aspects.size > 0 ? stage.plan_post_aspects.size : 0)
  end

  def rowspan_concept(concept)
    2 + concept.plan_post_actions.size
  end

  def rowspan_stage_show(stage)
    1 + stage.plan_post_aspects.size + stage.actions_rowcount.size
  end

  def rowspan_concept_show(concept)
    1 + concept.plan_post_actions.size
  end

  def color_stage(stage)
    case stage
      when 1
        'color-teal'
      when 2
        'color-red'
      when 3
        'color-orange'
      when 4
        'color-green'
      when 5
        'color-grey'
    end
  end

  def stage_status(stage)
    case stage
      when 1
        'Сбор информации'
      when 2
        'Сбор несовершенств'
      when 3
        'Сбор нововведений'
      when 4
        'Создание проектов'
      when 5
        'Выставление оценок'
    end
  end

  def current_stage?(stage)
    if stage == 1 and @project.status == 2
      true
    elsif stage == 2 and @project.status == 6
      true
    elsif stage == 3 and @project.status == 8
      true
    elsif stage == 4 and @project.status == 9
      true
    elsif stage == 5 and @project.status == 11
      true
    else
      false
    end
  end

  def number_stage(current_stage)
    case current_stage
      when 'life_tape/posts'
        1
      when 'discontent/posts'
        2
      when 'concept/posts'
        3
      when 'plan/posts'
        4
      when 'estimate/posts'
        5
      else
        1
    end
  end

  def stage_for_essay(stage)
    case stage
      when 1
        'life_tape/posts'
      when 2
        'discontent/posts'
      when 3
        'concept/posts'
      when 4
        'plan/posts'
      when 5
        'estimate/posts'
      else
        'life_tape/posts'
    end
  end


  def stage_for_essay_link(stage)
    case stage
      when 1
        :lifetape
      when 2
        :discontent
      when 3
        :concept
      when 4
        :plan
      when 5
        :estimate
      else
        :lifetape
    end
  end

  def css_label_status(status)
    case status
      when 'discontent'
        'label-danger'
      when 'concept'
        'label-warning'
      else
        ''
    end
  end

  def label_discuss_stat(comment)
    case comment.discuss_status
      when false
        'label-default'
      when true
        'label-danger'
      else
        'label-default'
    end
  end
  def get_class_for_improve(stage)
    case stage
      when 1
        'LifeTape'
      when 2
        'Discontent'
      when 3
        'Concept'
      when 4
        'Plan'
      when 5
        'Estimate'
      when 6
        'Essay'
    end
  end
  def get_stage_for_improve(c)
    case c
      when 'LifeTape'
        1
      when 'Discontent'
        2
      when 'Concept'
        3
      when 'Plan'
        4
      when 'Estimate'
        5
      when 'Essay'
        6
    end
  end

  def improve_comment(post)
    if post.improve_comment and post.improve_stage
      comment = "#{get_class_for_improve(post.improve_stage)}::Comment".constantize.find(post.improve_comment)
      case post.improve_stage
        when 1
          "| Доработано из " + (link_to "предложения ", "/project/#{@project.id}/life_tape/posts?asp=#{comment.post.discontent_aspects.first.id}#comment_#{comment.id}") + (link_to comment.user, user_path(@project, comment.user))
        when 2
          "| Доработано из " + (link_to "предложения ", "/project/#{@project.id}/discontent/posts/#{comment.post.id}#comment_#{comment.id}") + (link_to comment.user, user_path(@project, comment.user))
        when 3
          "| Доработано из " + (link_to "предложения ", "/project/#{@project.id}/concept/posts/#{comment.post.id}#comment_#{comment.id}") + (link_to comment.user, user_path(@project, comment.user))
      end
    end
  end

  def link_for_improve(comment)
    comment_class = get_stage_for_improve(comment.get_class)
    case comment_class
      when 1
        link_to "/project/#{@project.id}/life_tape/posts?asp=#{comment.post.discontent_aspects.first.id}#comment_#{comment.id}" do
          content_tag :span, 'Источник', class: 'label label-primary'
        end
      when 2
        link_to "/project/#{@project.id}/discontent/posts/#{comment.post.id}#comment_#{comment.id}" do
          content_tag :span, 'Источник', class: 'label label-primary'
        end
      when 3
        link_to "/project/#{@project.id}/concept/posts/#{comment.post.id}#comment_#{comment.id}" do
          content_tag :span, 'Источник', class: 'label label-primary'
        end
    end
  end

  def comment_stat_color(comment)
    if comment.discuss_status
      'discuss_comment'
    elsif comment.user.role_stat == 2
      'expert_comment'
    end
  end

  def status_project(project)
    if project.status == 0 or project.type_access == 5
      "Идет подготовка к процедуре"
    elsif [1,2].include? project.status
      "Идет 1 этап"
    elsif [3,4,5,6].include? project.status
      "Идет 2 этап"
    elsif [7,8].include? project.status
      "Идет 3 этап"
    elsif [9].include? project.status
      "Идет 4 этап"
    elsif [10,11,12].include? project.status
      "Идет 5 этап"
    elsif [20].include? project.status
      "Завершена"
    end
  end

  def field_for_journal(post)
    if post.instance_of? LifeTape::Post
      post.discontent_aspects.first.content unless post.discontent_aspects.first.nil?
    elsif post.instance_of? Concept::Post
      post.post_aspects.first.title unless post.post_aspects.first.nil?
    elsif post.instance_of? Plan::Post
      post.name
    else
      post.content
    end
  end

  def validate_knowbase(post)
    if post[:title].empty?
      flash[:title]='Заполните название статьи'
    end
    if post[:content].empty?
      flash[:content]='Заполните поле контента'
    end
    flash
  end

  def show_flash(flash)
    response = ""
    flash.each do |name, msg|
      response = response + content_tag(:div, msg, :id => "flash_#{name}",:class => "color-red",:style => "font-size:15px;")
    end
    flash.discard
    response
  end

  def role_label(user)
    if user.boss?
      content_tag :span, 'MD', class: 'label label-danger'
    elsif user.role_expert?
      content_tag :span, 'Эксперт', class: 'label label-success'
    end
  end

  def club_toggle_user(user)
    case user.type_user
      when 4
        5
      when 5
        4
      else
        4
    end
  end

  def current_stage_for_navbar(controller, stage)
    if controller.instance_of? LifeTape::PostsController
      :lifetape
    elsif controller.instance_of? Discontent::PostsController
      :discontent
    elsif controller.instance_of? Concept::PostsController
      :concept
    elsif controller.instance_of? Plan::PostsController
      :plan
    elsif controller.instance_of? Estimate::PostsController
      :estimate
    elsif controller.instance_of? Essay::PostsController
      stage_for_essay_link(stage.to_i)
    else
      :lifetape
    end
  end

  def current_controller_for_navbar?(controller)
    if [LifeTape::PostsController,Discontent::PostsController,Concept::PostsController,Plan::PostsController,Estimate::PostsController,Essay::PostsController].include?(controller.class)
      return true
    end
    false
  end

  def label_for_comment_status(comment,status,title)
    if comment.check_status_for_label(status)
      if current_user?(comment.user) or boss?
        link_to({:controller => comment.controller_name_for_action, :action => :comment_status, :id => comment.post.id, :comment_id => comment.id, status => 1, :comment_stage => get_stage_for_improve(comment.get_class)},  :remote => true, :method => :put,  id: "#{status}_comment_#{comment.id}") do
          content_tag( :span, title, :class=>"label #{css_label_status(status)}")
        end
      else
        content_tag( :span, title, :class=>"label #{css_label_status(status)}")
      end
    else
      if current_user?(comment.user) or boss?
        link_to({:controller => comment.controller_name_for_action, :action => :comment_status, :id => comment.post.id, :comment_id => comment.id, status => 1, :comment_stage => get_stage_for_improve(comment.get_class)},  :remote => true, :method => :put,  id: "#{status}_comment_#{comment.id}") do
          content_tag( :span, title, :class=>"label label-default")
        end
      end
    end
  end

end