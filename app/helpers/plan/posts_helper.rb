# encoding: utf-8
module Plan::PostsHelper
  def display_title(cp)
    if not cp.title.nil? and cp.title != ''
      cp.title
    elsif not cp.discontent.nil?
      cp.discontent.display_content
    elsif not cp.name.nil? and cp.name != ''
      trim_string(cp.name)
    else
      '---'
    end
  end

  def plus_concept?(stage,concept)
    if stage.plan_post_aspects.pluck(:concept_post_aspect_id).include? concept.post_aspects.first.id
      return true
    end
    false
  end

  def tag_for_concept(num)
    case num
      when 1
        'novation_what'
      when 2
        'novation_how'
      when 3
        'cond'
      when 4
        'negative_h'
      when 5
        'problems'
      when 6
        'reality'
    end
  end

  def column_for_concept(num)
    case num
      when 1
        'name'
      when 2
        'content'
      when 3
        'positive'
      when 4
        'negative'
      when 5
        'problems'
      when 6
        'reality'
    end
  end

  def field_for_concept(num)
    case num
      when 1
        'A1'
      when 2
        'A2'
      when 3
        'B1'
      when 4
        'C1'
      when 5
        'D1'
      when 6
        'D2'
    end
  end

  def check_validate_concept(concept)
    concept_aspect = concept.concept_post_aspect
    if concept_aspect
      notice_empty = "Поля не заполнены "
      notice_adap = "Поля не адаптированны под текущий проект "
      notice_note = "Поля имеюшие замечания от модератора "
      6.times do |n|
        link = link_to "#{field_for_concept(n+1)}", "/project/#{@project.id}/plan/posts/#{@post.id}/edit_concept?con_id=#{concept.id}&edit_concept=#{'true'}&num=#{n+1}##{tag_for_concept(n+1)}", :method => :put, :remote => true
        if concept.send(column_for_concept(n+1)) == concept_aspect.send(column_for_concept(n+1))
          notice_adap = notice_adap + link
        end
        if concept.send(column_for_concept(n+1)).empty?
          notice_empty = notice_empty + link
        end
        n = 5 if n+1 == 4
        n = 7 if n+1 == 5
        n = 8 if n+1 == 6
        if concept_aspect.concept_post.note_size?(n)
          notice_note = notice_note + link
        end
      end
      return (notice_empty+"<br/>" if notice_empty.present?) + (notice_adap+"<br/>" if notice_adap.present?) + (notice_note+"<br/>" if notice_note.present?)
    end
  end


  # def improve_comment(post)
  #   if post.imp_comment and post.imp_stage
  #     comment = "#{get_class_for_improve(post.imp_stage)}::Comment".constantize.find(post.imp_comment)
  #     case post.imp_stage
  #       when 1
  #         "Доработано из " + (link_to "предложения ", "/project/#{@project.id}/life_tape/posts?asp=#{comment.post.discontent_aspects.first.id}#comment_#{comment.id}") + (link_to comment.user, user_path(@project, comment.user))
  #       when 2
  #         "Доработано из " + (link_to "предложения ", "/project/#{@project.id}/discontent/posts/#{comment.post.id}#comment_#{comment.id}") + (link_to comment.user, user_path(@project, comment.user))
  #       when 3
  #         "Доработано из " + (link_to "предложения ", "/project/#{@project.id}/concept/posts/#{comment.post.id}#comment_#{comment.id}") + (link_to comment.user, user_path(@project, comment.user))
  #     end
  #   end
  # end
  #
  # def link_for_improve(comment)
  #   com_class = get_stage_for_improve(comment.get_class)
  #   case com_class
  #     when 1
  #       link_to "/project/#{@project.id}/life_tape/posts?asp=#{comment.post.discontent_aspects.first.id}#comment_#{comment.id}" do
  #         content_tag :span, 'Источник', class: 'label label-primary'
  #       end
  #
  #     when 2
  #       link_to "/project/#{@project.id}/discontent/posts/#{comment.post.id}#comment_#{comment.id}" do
  #         content_tag :span, 'Источник', class: 'label label-primary'
  #       end
  #     when 3
  #       link_to "/project/#{@project.id}/concept/posts/#{comment.post.id}#comment_#{comment.id}" do
  #         content_tag :span, 'Источник', class: 'label label-primary'
  #       end
  #   end
  # end


end
