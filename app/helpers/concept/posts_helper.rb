module Concept::PostsHelper
  def trim_post_content(content, size = 100)
    if !content.nil? and content.length > size
      return content[0..size] + ' ...'
    end
    content
  end

  def post_discontent_classes(post)
    classes = ''
    post.concept_disposts.each do |dispost|
      classes += "discontent_#{dispost.id} "
    end
    classes
  end
end
