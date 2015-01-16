module Discontent::PostsHelper
  def render_post_notes(post_field, type_fd)
    text = '<ul>'
    post_field.post_notes(type_fd).each do |dpn|
      text+='<li>'+dpn.content+'</li>'
    end
    text+='</ul>'
    text.html_safe
  end

  def first_post_for_vote?(post)
    if @project.get_united_posts_for_vote(current_user).size == 1
      false
    else
      if @project.get_united_posts_for_vote(current_user).pluck(:id).min != post
        true
      else
        false
      end
    end
  end

  def id_for_type_field(field)
    case field
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

  def name_for_type_field(field)
    case field
      when 'what'
        t('form.discontent.what')
      when 'where'
        t('form.discontent.where')
      when 'when'
        t('form.discontent.when')
      else
        nil
    end
  end

  def number_for_type_field(field)
    case field
      when 'what'
        1
      when 'where'
        2
      when 'when'
        3
      else
        nil
    end
  end

  def class_for_type_field(post, field)
    if (field == 'what' and post.status_content == true) or (field == 'where' and post.status_whered == true) or (field == 'when' and post.status_whend == true)
      'label-success'
    elsif (field == 'what' and post.status_content == false) or (field == 'where' and post.status_whered == false) or (field == 'when' and post.status_whend == false)
      'label-danger'
    else
      'label-g'
    end
  end

  def column_for_type_field_discontent(field)
    case field
      when 'what'
        'content'
      when 'where'
        'whered'
      when 'when'
        'whend'
      else
        ''
    end
  end

  def validate_dispost(pa, aspects)
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
      response = response + content_tag(:div, msg, id: "flash_#{name}", class: "text-danger", style: "font-size:15px;")
    end
    flash.discard
    response
  end

  def content_for_field(post_content, field, link = false)
    html = ''
    if link
      html << link_to({controller: 'discontent/posts', action: :status_post, id: post_content.id, type_field: number_for_type_field(field)}, remote: true, method: :put, id: "label_dispost_#{post_content.id}", class: "note_text") do
        content_tag :span, name_for_type_field(field), class: "label #{class_for_type_field(post_content, field)}", id: "#{field}_#{post_content.id}"
      end
      html << link_to({controller: 'discontent/posts', action: :new_note, id: post_content.id, type_field: number_for_type_field(field)}, remote: true, method: :put, id: "content_dispost_#{post_content.id}_#{number_for_type_field(field)}", class: "note_text") do
        content_tag :span, post_content.send(column_for_type_field_discontent(field)), id: "#{field}_content_#{post_content.id}"
      end
    else
      html << content_tag(:span, name_for_type_field(field), class: "label #{class_for_type_field(post_content, field)}", id: "#{field}_#{post_content.id}")
      html << content_tag(:span, post_content.send(column_for_type_field_discontent(field)), id: "#{field}_content_#{post_content.id}")
    end
    if [2, 4].include?(post_content.status) and field == 'what'
      html << content_tag(:ul, '', class: "ul-union-list", id: "post_content_#{post_content.id}") do
        post_content.discontent_posts.each do |dp|
          concat content_tag(:li, dp.content, class: "union-list", id: "li_id_#{dp.id}")
        end
      end
    end
    html.html_safe
  end

  def content_for_note(post_content, field, link = false)
    note_able = post_content.notes.by_type(number_for_type_field(field)).present?
    html = ''
    html << '<br></br><code><strong> Рекомендация: </strong>' if note_able
    html << content_tag(:ul, '', class: "discuss_comment", id: "note_form_#{post_content.id}_#{number_for_type_field(field)}") do
      post_content.notes.by_type(number_for_type_field(field)).each do |dpn|
        concat content_tag(:div, '', id: "post_note_#{dpn.id}") {
                 link ? link_to({controller: 'discontent/posts', action: :destroy_note, id: post_content.id, note_id: dpn.id, type_field: number_for_type_field(field)}, remote: true, method: :put, data: {confirm: t('confirm.delete_note')}, id: "destroy_post_note_#{dpn.id}") { content_tag(:span, '', class: "glyphicon glyphicon-remove text-danger pull-right") } + content_tag(:li, dpn.content, id: "li_note_#{dpn.id}") : content_tag(:li, dpn.content, id: "li_note_#{dpn.id}")
               }
      end
    end
    html << '</code>' if note_able
    html.html_safe
  end


  def post_aspect_classes(post)
    classes = ''
    post.post_aspects.each do |asp|
      classes += "aspect_#{asp.id} "
    end
    classes
  end

  def rate_aspect(asp)
    status = @project.status > 6 ? 1 : 0
    count_all = @project.discontents.by_status(status).count
    count_aspect = asp.aspect_posts.by_status(status).count
    count_all == 0 ? 0 : ((count_aspect.to_f/count_all.to_f)*100).round
  end
end
