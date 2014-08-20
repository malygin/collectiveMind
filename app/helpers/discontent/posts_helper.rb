# encoding: utf-8
module Discontent::PostsHelper
  def render_post_notes(post_field,type_fd)
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

  #def column_for_type_field(type_fd)
  #  case type_fd
  #    when 1
  #      'status_content'
  #    when 2
  #      'status_whered'
  #    when 3
  #      'status_whend'
  #    else
  #      nil
  #  end
  #end
  def validate_dispost(pa,aspects)
    if pa[:content].empty?
      flash[:content]='Заполните поле "что"'
    end
    if pa[:whered].empty?
      flash[:whered]='Заполните поле "где"'
    end
    if pa[:whend].empty?
      flash[:whend]='Заполните поле "когда"'
    end
    if aspects.nil?
      flash[:aspects]='Выберите тему несовершенства'
    end
    if pa[:style].nil?
      flash[:style]='Выберите тип несовершенства'
    end
    flash
  end

  def flash_display
    response = ""
    flash.each do |name, msg|
      response = response + content_tag(:div, msg, :id => "flash_#{name}",:class => "text-danger",:style => "font-size:15px;")
    end
    flash.discard
    response
  end

end