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
end
