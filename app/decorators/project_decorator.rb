class ProjectDecorator
  attr_reader :project
  def initialize(project)
    @project = project
  end

  # выборка пользователей по баллам за стадию
  def sort_user_score(type_score = 'collect_info_posts_score')
    project.users_in_project.reorder("core_project_users.#{type_score} DESC NULLS LAST").limit(10)
  end

  # выборка пользователей по баллам за стадию
  def sort_user_like(stage = :collect_info_posts)
    # stage = :core_aspect_posts if stage == :collect_info_posts
    project.users_in_project.sort_by { |user| -(user.likes_posts_for(stage, project).count + user.likes_comments_for(stage, project).count) }.first(3)
  end

  def results_all(stage = :collect_info_posts)
    if stage == :collect_info_posts
      aspects
    elsif stage == :discontent_posts
      discontents
    elsif stage == :concept_posts
      concepts
    elsif stage == :novation_posts
      novations
    elsif stage == :plan_posts
      plan_post
    end
  end

  def results_for_next(stage = :collect_info_posts)
    if stage == :collect_info_posts
      proc_aspects
    elsif stage == :discontent_posts
      discontent_ongoing_post
    elsif stage == :concept_posts
      concept_ongoing_post
    elsif stage == :novation_posts
      novation_published_post
    elsif stage == :plan_posts
      plan_published_post
    end
  end

  def method_missing(method_name, *args, &block)
    project.send(method_name, *args, &block)
  end

  def respond_to_missing?(method_name, include_private = false)
    project.respond_to?(method_name, include_private) || super
  end
end
