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

  # аспекты для голосования (необходимые, важные, неважные)
  def aspects_for_vote(project, status)
    user.voted_aspect_posts.by_project(project.id).where(aspect_votings: { status: status })
  end

  # аспекты за которые пользователь еще не проголосовал
  def unvote_aspects_for_vote(project)
    vote_aspects = project.main_aspects.joins(:final_votings).where(aspect_votings: { user_id: user.id }).pluck('aspect_posts.id')
    project.main_aspects.where.not(id: vote_aspects)
  end

  # несовершенства для голосования (необходимые, важные, неважные)
  def discontents_for_vote(project, status)
    user.voted_discontent_posts.by_project(project.id).where(discontent_votings: { status: status })
  end

  # несовершенства за которые пользователь еще не проголосовал
  def unvote_discontents_for_vote(project)
    vote_discontents = project.discontent_posts_for_vote.joins(:final_votings).where(discontent_votings: { user_id: user.id }).pluck('discontent_posts.id')
    project.discontent_posts_for_vote.where.not(id: vote_discontents)
  end

  # идеи для голосования (да, нет)
  def concepts_for_vote(project, status)
    user.voted_concept_posts.by_project(project.id).where(concept_votings: { status: status })
  end

  # идеи за которые пользователь еще не проголосовал
  def unvote_concepts_for_vote(project)
    vote_concepts = project.concept_posts_for_vote.joins(:final_votings).where(concept_votings: { user_id: user.id }).pluck('concept_posts.id')
    project.concepts_for_discussion.where.not(id: vote_concepts)
  end

  # пакеты для голосования (да, нет)
  def novations_for_vote(project, status)
    user.voted_novation_posts.by_project(project.id).where(novation_votings: { status: status })
  end

  # пакеты за которые пользователь еще не проголосовал
  def unvote_novations_for_vote(project)
    vote_novations = project.novation_posts_for_vote.joins(:final_votings).where(novation_votings: { user_id: user.id }).pluck('novation_posts.id')
    project.novation_posts_for_vote.where.not(id: vote_novations)
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
