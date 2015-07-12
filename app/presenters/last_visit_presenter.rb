class LastVisitPresenter
  def initialize(hash={})
    @project = hash[:project]
    @user = hash[:user]
    @controller = hash[:controller]
    # hash.each_pair { |key, value| self.send :"#{key}=", value }
  end

  def content_after_last_visit_for
    # after_last_visit_for(type_content)
    # @project.content_after_last_visit_for(type_content, @controller.gsub('/', '_'), @user)
    # @project.content_after_last_visit_for(type_content, name_controller, user)
    {
      comments: after_last_visit_for(:comments).size,
      posts: after_last_visit_for(:posts).size
    }
  end

  def content_after_last_visit_for_post(post)
    {
        comments: after_last_visit_for_post(post, :comments).size,
        posts: after_last_visit_for_post(post, :posts).size
    }
  end

  def content_with_counters
    stage = @controller.to_s.gsub('/posts', '').pluralize
    @project.send("discontents_for_discussion").map do |post|
      {post: post}.merge(content_after_last_visit_for_post(post))
      # [post, content_after_last_visit_for_post(post)]
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
    notice = @user.loggers.where(type_event: type_event, project_id: @project.id)
                 .where('body = ?', "/project/#{@project.id}/#{@controller}" + post_id).order(created_at: :desc).first
    notice ? notice.created_at : '2000-01-01 00:00:00'
  end
end
