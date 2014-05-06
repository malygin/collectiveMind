# encoding: utf-8
module Discontent::PostsHelper
  #def render_post_notes(type_field, post)
  #
  #  text = "<div id='where_form_#{post}_#{type_field}'>"
  #  Discontent::Post.find(post).post_notes(type_field).each do |dpn|
  #    text = text + "<li id='li_note_#{dpn.id}'>#{dpn.content}</li>"
  #  end
  #  text + "</div>"
  #end
  def render_post_notes(post_field,type_fd)
    #content_tag :ul do
    #  post_field.post_notes(type_fd).each do |dpn|
    #    '<li>'+dpn.content+'</li>'
    #    #content_tag :li do
    #    #  dpn.content
    #    #end
    #  end
    #end
    text = '<ul>'
    post_field.post_notes(type_fd).each do |dpn|
      text+='<li>'+dpn.content+'</li>'
    end
    text+='</ul>'
    text.html_safe
  end
  def first_post_for_vote?(post)
    if @project.get_united_posts_for_vote( current_user).size == 1
      false
    else
      if @project.get_united_posts_for_vote(current_user).pluck(:id).min != post
        true
      else
        false
      end
    end
  end

  def id_for_type_field(type_fd)
    case type_fd
      when 1
        'what'
      when 2
        'where'
      when 3
        'when'
      else
        nil
    end
  end

  def name_for_type_field(type_fd)
    case type_fd
      when 1
        'что'
      when 2
        'где'
      when 3
        'когда'
      else
        nil
    end
  end

  def class_for_type_field(post_field,type_fd)
    case type_fd
      when 1
        if post_field.status_content == true
          'label-success'
        elsif post_field.status_content == false
          'label-danger'
        else
          'label-g'
        end
      when 2
        if post_field.status_whered == true
          'label-success'
        elsif post_field.status_whered == false
          'label-danger'
        else
          'label-g'
        end
      when 3
        if post_field.status_whend == true
          'label-success'
        elsif post_field.status_whend == false
          'label-danger'
        else
          'label-g'
        end
      else
        nil
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
        nil
    end
  end


end