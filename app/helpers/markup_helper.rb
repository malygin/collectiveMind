module MarkupHelper
  # @todo bad markup in body not css for different stage
  def stage_theme
    if rating?
      'grey_theme'
    elsif action_name == 'user_content' || controller_name == 'users'
      "stage#{@project.main_stage}_theme"
    else
      "stage#{number_current_stage}_theme"
    end
  end

  def trim_content(content, size = 100)
    return content[0..size] + ' ...' if !content.nil? && content.length > size
    content
  end

  def post_concept_classes(post)
    post.novation_concepts.map { |c| "concept_#{c.id}" }.join(' ')
  end

  def post_aspect_classes(post)
    post.post_aspects.map { |c| "aspect_#{c.id}" }.join(' ')
  end

  def post_discontent_classes(post)
    post.concept_disposts.map { |c| "discontent_#{c.id}" }.join(' ')
  end

  def user_image_tag(source, options = {})
    if source
      cl_image_tag source, options
    else
      image_tag 'no-ava.png', options
    end
  end

  def escape_text(t)
    t.gsub("\n", '\\n').gsub("\r", '\\r').gsub("\t", '\\t').gsub("'", "\\'")
  end

  def label_approve_stat(comment)
    case comment.approve_status
      when false
        'label-default'
      when true
        'label-success'
      else
        'label-default'
    end
  end

  # rubocop:disable Metrics/MethodLength
  def color_progress_bar
    case name_controller
      when :collect_info_posts
        '#649ac3'
      when :discontent_posts
        '#486795'
      when :concept_posts
        '#bd8cb8'
      when :novation_posts
        '#7373aa'
      when :plan_posts
        '#80bcc4'
      when :estimate_posts
        '#80bcc4'
      else
        '#649ac3'
    end
  end
end
