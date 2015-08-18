module UserStatistics
  def content_for_project(stage, project)
    send(stage).by_project(project.id)
  end

  def comment_for_project(stage, project)
    send(stage.to_s.gsub('_posts', '_comments')).joins(:post).where("#{stage}.project_id = ?", project)
  end

  def like_content_for(stage, project)
    send('voting_' + stage.to_s).joins(:post).where("#{stage}.project_id = ?", project)
  end

  def like_comment_for(stage, project)
    send('voting_' + stage.to_s.gsub('_posts', '_comments')).joins(:comment)
      .joins("INNER JOIN #{stage} ON #{stage}.id = #{stage.to_s.gsub('_posts', '_comments')}.post_id").where("#{stage}.project_id = ?", project)
  end

  def approve_content_for(stage, project)
    send(stage).by_project(project.id).where(approve_status: true)
  end

  def approve_comment_for(stage, project)
    send(stage.to_s.gsub('_posts', '_comments')).joins(:post).where("#{stage}.project_id = ?", project).where(approve_status: true)
  end

  def likes_posts_for(stage, project)
    send(stage).by_project(project.id).joins(:post_votings)
  end

  def likes_comments_for(stage, project)
    send(stage.to_s.gsub('_posts', '_comments')).joins(:post).where("#{stage}.project_id = ?", project).joins(:comment_votings)
  end
end
