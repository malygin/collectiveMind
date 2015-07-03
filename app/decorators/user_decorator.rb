class UserDecorator
  attr_reader :user
  def initialize(user)
    @user = user
  end

  def content_for_vote(project, num_folder = nil)
    # если не паредаем статус, то просто возвращаем общее количество постов за которые проголосовал пользователь
    return user.send("voted_#{project.current_stage_type}").by_project(project.id) unless num_folder
    # если это общая папка, то выбираем контент за который пользователь еще не голосовал
    if num_folder == 0
      voted_content = project.send("#{project.current_stage_type}_for_vote").joins(:final_votings).where("#{project.current_stage_title}_votings.user_id = ?", user.id)
                      .pluck("#{project.current_stage_type}.id")
      project.send("#{project.current_stage_type}_for_vote").where.not(id: voted_content)
    else
      user.send("voted_#{project.current_stage_type}").by_project(project.id).where("#{project.current_stage_title}_votings.status = ?", num_folder)
    end
  end

  def count_posts_for_progress(project)
    [project.send("#{project.current_stage_type}_for_vote").count, content_for_vote(project).count]
  end

  def plan_vote_status(post, type)
    plan_post_votings.by_post(post).by_type(type).first.try(:status) || 0
  end

  def method_missing(method_name, *args, &block)
    user.send(method_name, *args, &block)
  end

  def respond_to_missing?(method_name, include_private = false)
    user.respond_to?(method_name, include_private) || super
  end
end
