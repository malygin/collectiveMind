module JournalHelper
  # rubocop:disable Metrics/MethodLength
  def journal_icon(j)
    case j
      when /_approve_status/
        'fa-exclamation'
      when /_comment_dislike/
        'fa-thumbs-down'
      when /_comment_like/
        'fa-thumbs-up'
      when /reply_/
        'fa-reply'
      when /_post_save/
        'fa-plus'
      when /my_add_score_/
        'fa-trophy'
      when /_comment/
        'fa-comment'
    end
  end

  def journal_color(j)
    case j
    when  /core_aspect/
      'font_color_stage1'
    when /discontent/
      'font_color_stage2'
    when /novation/
      'font_color_stage3'
    when /concept/
      'font_color_stage4'
    when /plan/
      'font_color_stage5'
    end
  end

  def path_from_journal_event(type_event)
    case type_event
    when /core_aspec/
      'collect_info/posts'
    when /discontent_post/
      'discontent/posts'
    when /concept_post/
      'concept/posts'
    when /novation_post/
      'novation/posts'
    when /plan_post/
      'plan/posts'
    when /estimate_post/
      'estimate/posts'
    end
  end

  def journal_parser(j, project)
    case j.type_event
      when /_add_score/
        t(j.type_event, body: j.body) + link_to("#{j.body}..", "/project/#{project}/#{path_from_journal_event(j.type_event)}?jr_post=#{j.first_id}&viewed=true")
      when /_post/
        t(j.type_event) + link_to("#{j.body}..", "/project/#{project}/#{path_from_journal_event(j.type_event)}?jr_post=#{j.first_id}&viewed=true")
      when /_comment/
        t(j.type_event, body: j.body) +
          link_to("#{j.body2}... ", "/project/#{project}/#{path_from_journal_event(j.type_event)}?jr_post=#{j.first_id}&jr_comment=#{j.second_id}#comment_#{j.second_id}")
      else
        'что то другое'
    end
  end

  def class_for_journal(current_user, journal)
    if current_user && current_user.last_seen_news && current_user.last_seen_news > journal.created_at
      ''
    else
      'unread_news'
    end
  end
end
