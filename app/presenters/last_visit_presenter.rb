class LastVisitPresenter
  attr_accessor :posts, :comments

  def initialize(hash = {})
    @project = hash[:project]
    @controller = hash[:controller]
    @user = hash[:user]
    @comments = after_last_visit_for(:comments)
    @posts = after_last_visit_for(:posts)
  end

  def content_after_last_visit_for
    {
      comments: after_last_visit_for(:comments),
      posts: after_last_visit_for(:posts)
    }
  end

  def content_after_last_visit_for_post(post)
    {
      comments: after_last_visit_for_post(post, :comments),
      posts: after_last_visit_for_post(post, :posts)
    }
  end

  def content_with_counters
    # stage = @controller.to_s.gsub('/posts', '').pluralize
    @project.discontents_for_discussion.map do |post|
      { post: post }.merge(content_after_last_visit_for_post(post))
    end
  end

  def after_last_visit_for_post(post, type_content)
    post.related_next_posts.send("after_last_visit_#{type_content}", last_time_visit_page).size
  end

  def after_last_visit_for(type_content)
    stage = @controller.to_s.gsub('/posts', '').pluralize
    @project.send("#{stage}_for_discussion").send("after_last_visit_#{type_content}", last_time_visit_page).size
  end

  def last_time_visit_page(type_event = 'visit_save', post = nil)
    post_id = post ? "/#{post.id}" : ''
    notice = @user.loggers.by_type_event(type_event).by_project(@project.id).by_format('html')
             .where('body = ?', "/project/#{@project.id}/#{@controller}" + post_id).first
    notice ? notice.created_at : '2000-01-01 00:00:00'
  end
end
