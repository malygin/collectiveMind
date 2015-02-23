module CollectInfo::PostsHelper
  def trim_string(content, size = 200)
    if !content.nil? and content.length > size
      return content[0..size] + ' ...'
    end
    content
  end
end
