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

  def plus_concept?(stage, concept)
    if stage.plan_post_aspects.pluck(:concept_post_aspect_id).include? concept.post_aspects.first.id
      return true
    end
    false
  end

  def plus_concept_new_idea?(stage, concept)
    if stage.plan_post_aspects.pluck(:id).include? concept.id
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
        'cond_res'
      when 5
        'cond_s'
      when 6
        'negative_h'
      when 7
        'negative_res'
      when 8
        'negative_s'
      when 9
        'control'
      when 10
        'control_res'
      when 11
        'control_s'
      when 12
        'obstacles_bcd'
      when 13
        'problems'
      when 14
        'reality'
    end
  end

  def field_for_res(num)
    case num
      when 4
        'positive_r'
      when 5
        'positive_s'
      when 7
        'negative_r'
      when 8
        'negative_s'
      when 10
        'control_r'
      when 11
        'control_s'
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
      when 6
        'negative'
      when 9
        'control'
      when 12
        'obstacles'
      when 13
        'problems'
      when 14
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
        'B2'
      when 5
        'B3'
      when 6
        'C1'
      when 7
        'C2'
      when 8
        'C3'
      when 9
        'D1'
      when 10
        'D2'
      when 11
        'D3'
      when 12
        'E1'
      when 13
        'F1'
      when 14
        'F2'
    end
  end

  def check_validate_concept(concept, view = false)
    if concept
      concept_post = concept.concept_post

      notice_prefix_empty = t('form.plan.concept.notice_prefix_empty')
      notice_prefix_adap = t('form.plan.concept.notice_prefix_adap')
      notice_prefix_note = t('form.plan.concept.notice_prefix_note')
      notice_empty = ''
      notice_adap = ''
      notice_note = ''
      14.times do |n|
        if view
          link = content_tag :span, "#{field_for_concept(n+1)}", class: "badge badge-danger"
        else
          link = link_to "#{field_for_concept(n+1)} ", "/project/#{@project.id}/plan/posts/#{@post.id}/edit_concept?con_id=#{concept.id}&tag_field=#{tag_for_concept(n+1)}", method: :put, remote: true, class: "badge badge-danger"
        end
        if [4, 7].include?(n+1)
          if !concept.plan_post_resources.by_type(field_for_res(n+1)).present?
            notice_empty += link if link
          elsif concept_post
            old_resources = concept_post.concept_post_resources.by_type(field_for_res(n+1)).pluck(:name) unless concept_post.concept_post_resources.by_type(field_for_res(n+1)).nil?
            old_desc = concept_post.concept_post_resources.by_type(field_for_res(n+1)).pluck(:desc) unless concept_post.concept_post_resources.by_type(field_for_res(n+1)).nil?
            new_resources = concept.plan_post_resources.by_type(field_for_res(n+1)).pluck(:name) unless concept.plan_post_resources.by_type(field_for_res(n+1)).nil?
            new_desc = concept.plan_post_resources.by_type(field_for_res(n+1)).pluck(:desc) unless concept.plan_post_resources.by_type(field_for_res(n+1)).nil?

            if old_resources == new_resources and old_desc == new_desc
              notice_adap += link if link
            end
          end
          if concept.note_size?(n+1)
            notice_note += link if link
          end
        elsif [5, 8, 10, 11].include?(n+1)
          if n+1 == 10
            if !concept.plan_post_resources.by_type(field_for_res(n+1)).present?
              notice_empty += link if link
            end
          else
            #if !concept.plan_post_means.by_type(field_for_res(n+1)).present?
            #  notice_empty += link if link
            #end
          end
          if concept.note_size?(n+1)
            notice_note += link if link
          end
        else
          if !concept.send(column_for_concept(n+1)).present?
            notice_empty += link if link
          elsif concept_post
            if ![9, 12].include?(n+1) and concept.send(column_for_concept(n+1)) == concept_post.send(column_for_concept(n+1))
              notice_adap += link if link
            end
          end
          cn = 5 if n+1 == 6
          cn = 7 if n+1 == 13
          cn = 8 if n+1 == 14
          if concept.note_size?(n+1)
            notice_note += link if link
          end
          if concept_post
            notice_note += link if link and concept_post.note_size?(cn)
          end
        end
      end
      (notice_empty.present? ? "<i class=\"fa fa-exclamation-triangle\"></i>" + notice_prefix_empty + notice_empty + "<br/>" : '') + (notice_adap.present? ? "<i class=\"fa fa-bell\"></i>" + notice_prefix_adap + notice_adap + "<br/>" : '') + (notice_note.present? ? "<i class=\"fa fa-comment\"></i>" + notice_prefix_note + notice_note + "<br/>" : '')
    end
  end
end
