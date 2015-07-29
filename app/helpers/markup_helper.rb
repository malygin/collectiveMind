module MarkupHelper
  # @todo bad markup in body not css for different stage
  def stage_theme
    if rating?
      'grey_theme'
    elsif @project.status == 100
      "stage_#{number_current_stage}"
    elsif action_name == 'user_content' || controller_name == 'users'
      "stage_#{@project.main_stage}"
    else
      "stage_#{number_current_stage}"
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
      if source.include?('collection_avatar_path:')
        image_tag source.gsub('collection_avatar_path:', ''), options
      else
        cl_image_tag source, options
      end
    else
      image_tag 'no-ava.png', options
    end
  end

  def user_image_path(source)
    if source
      if source.include?('collection_avatar_path:')
        image_path(source.gsub('collection_avatar_path:', ''))
      else
        cl_image_path(source)
      end
    else
      image_path('no-ava.png')
    end
  end

  def user_image_alt(source)
    if source
      if source.include?('collection_avatar_path:')
        image_alt(source.gsub('collection_avatar_path:', ''))
      else
        image_alt(source)
      end
    else
      image_alt('no-ava.png')
    end
  end

  def escape_text(t)
    t.gsub("\n", '\\n').gsub("\r", '\\r').gsub("\t", '\\t').gsub("'", "\\'")
  end

  # rubocop:disable Metrics/MethodLength
  def color_progress_bar
    case name_controller
      when :aspect_posts
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
