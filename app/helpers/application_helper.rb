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
    s[0..l]
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
		elsif stage =='discontent' and (@project.status==4)
			true
		elsif stage =='concept' and (@project.status==6)
			true	
		elsif stage =='plan' and (@project.status==8)
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

  def column_for_type_field(type_fd)
    case type_fd
      when 1
        'status_content'
      when 2
        'status_whered'
      when 3
        'status_whend'
      else
        null
    end
  end

  def column_for_concept_type(type_fd)
    case type_fd
      when 1
        'stat_name'
      when 2
        'stat_content'
      when 3
        'stat_positive'
      when 4
        'stat_positive_r'
      when 5
        'stat_negative'
      when 6
        'stat_negative_r'
      when 7
        'stat_problems'
      when 8
        'stat_reality'
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

  def rowspan_stage_show(stage)
    1 + stage.plan_post_aspects.size + stage.actions_rowcount.size
  end

end