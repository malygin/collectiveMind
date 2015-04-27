module Novation::PostsHelper
  def trim_post_content(content, size = 100)
    if !content.nil? and content.length > size
      return content[0..size] + ' ...'
    end
    content
  end

  def post_concept_classes(post)
    classes = ''
    post.novation_concepts.each do |concept|
      classes += "concept_#{concept.id} "
    end
    classes
  end
end
