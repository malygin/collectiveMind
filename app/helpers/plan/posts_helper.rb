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
end
