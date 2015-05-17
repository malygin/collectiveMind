module Discontent::PostsHelper
  def trim_post_content(content, size = 100)
    if !content.nil? and content.length > size
      return content[0..size] + ' ...'
    end
    content
  end

  def post_aspect_classes(post)
    classes = ''
    post.post_aspects.each do |asp|
      classes += "aspect_#{asp.id} "
    end
    classes
  end
end
