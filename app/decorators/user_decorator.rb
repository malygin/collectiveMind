class UserDecorator
  attr_reader :user
  def initialize(user)
    @user = user
  end

  # аспекты для голосования (необходимые, важные, неважные)
  def aspects_for_vote(project, status)
    user.voted_aspects.by_project(project.id).where(aspect_votings: { status: status })
  end

  # аспекты за которые пользователь еще не проголосовал
  def unvote_aspects_for_vote(project)
    vote_aspects = project.aspects_for_discussion.joins(:final_votings).where(aspect_votings: { user_id: user.id }).pluck('aspect_posts.id')
    project.aspects_for_discussion.where.not(id: vote_aspects)
  end

  # несовершенства для голосования (необходимые, важные, неважные)
  def discontents_for_vote(project, status)
    user.voted_discontent_posts.by_project(project.id).where(discontent_votings: { status: status })
  end

  # несовершенства за которые пользователь еще не проголосовал
  def unvote_discontents_for_vote(project)
    vote_discontents = project.discontents_for_vote.joins(:final_votings).where(discontent_votings: { user_id: user.id }).pluck('discontent_posts.id')
    project.discontents_for_vote.where.not(id: vote_discontents)
  end

  # идеи для голосования (да, нет)
  def concepts_for_vote(project, status)
    user.voted_concept_post.by_project(project.id).where(concept_votings: { status: status })
  end

  # идеи за которые пользователь еще не проголосовал
  def unvote_concepts_for_vote(project)
    vote_concepts = project.concepts_for_vote.joins(:final_votings).where(concept_votings: { user_id: user.id }).pluck('concept_posts.id')
    project.concepts_for_discussion.where.not(id: vote_concepts)
  end

  # пакеты для голосования (да, нет)
  def novations_for_vote(project, status)
    user.voted_novation_post.by_project(project.id).where(novation_votings: { status: status })
  end

  # пакеты за которые пользователь еще не проголосовал
  def unvote_novations_for_vote(project)
    vote_novations = project.novations_for_vote.joins(:final_votings).where(novation_votings: { user_id: user.id }).pluck('novation_posts.id')
    project.novations_for_vote.where.not(id: vote_novations)
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
