class ProjectResulter
  attr_reader :project

  def initialize(project)
    @project = project
  end

  # выборка пользователей по баллам за стадию
  def sort_user_score(type_score = 'aspect_posts_score')
    project.users.reorder("core_project_users.#{type_score} DESC NULLS LAST").limit(10)
  end

  # выборка пользователей по лайкам за стадию
  def sort_user_like(stage = :aspect_posts)
    project.users.sort_by { |user| -(user.likes_posts_for(stage, project).count + user.likes_comments_for(stage, project).count) }.first(3)
  end

  def count_of_added_contents(model)
    send(model).count
  end

  def count_of_contents_for_next_stage(model)
    send(model + '_for_discussion').count
  end

  def method_missing(method_name, *args, &block)
    project.send(method_name, *args, &block)
  end

  def respond_to_missing?(method_name, include_private = false)
    project.respond_to?(method_name, include_private) || super
  end
end
