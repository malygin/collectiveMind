class Core::Aspect::Post < ActiveRecord::Base
  include BasePost
  SCORE = 20

  cattr_accessor :array_subaspects

  belongs_to :core_aspect, class_name: 'Core::Aspect::Post', foreign_key: 'core_aspect_id'

  has_many :discontent_post_aspects, class_name: 'Discontent::PostAspect', foreign_key: :aspect_id
  has_many :knowbase_posts, class_name: 'Core::Knowbase::Post', foreign_key: :aspect_id
  has_many :aspect_posts, through: :discontent_post_aspects, source: :post, class_name: 'Discontent::Post'
  has_many :voted_users, through: :final_votings, source: :user
  has_many :final_votings, foreign_key: 'aspect_id', class_name: 'CollectInfo::Voting'
  has_many :core_aspects, class_name: 'Core::Aspect::Post', foreign_key: 'core_aspect_id'
  has_many :collect_info_user_answers, class_name: 'CollectInfo::UserAnswers', foreign_key: 'aspect_id'
  has_many :questions, -> { where status: 0 }, class_name: 'CollectInfo::Question', foreign_key: 'aspect_id'

  # has_many :missed_questions, -> { where(status: 0).includes(:user_answers).where(collect_info_user_answers: {question_id: nil}) }, class_name: 'CollectInfo::Question'

  validates :content, presence: true

  default_scope { order :id }

  scope :positive_posts, -> { joins(:discontent_posts).where('discontent_posts.style = ?', 0) }
  scope :negative_posts, -> { joins(:discontent_posts).where('discontent_posts.style = ?', 1) }
  scope :accepted_posts, -> { joins(:discontent_posts).where('discontent_posts.style = ?', 4) }

  scope :minus_view, ->(aspects) { where.not(core_aspect_posts: {id: aspects}) }
  scope :main_aspects, -> { where(core_aspect_posts: {core_aspect_id: nil}) }
  scope :vote_top, ->(revers) {
    if revers == '0'
      order('count("collect_info_votings"."user_id") DESC')
    elsif revers == '1'
      order('count("collect_info_votings"."user_id") ASC')
    else
      nil
    end
  }

  # выборка всех вопросов к аспекту на которые пользователь еще не ответил
  def missed_questions(user, type_questions)
    questions_answered = self.questions.by_type(type_questions).joins(:user_answers).where(collect_info_user_answers: {user_id: user.id}).pluck('collect_info_questions.id')
    self.questions.by_type(type_questions).where.not(id: questions_answered)
  end

  # только вопросы первой порции
  def user_answers_for_aspect
    self.collect_info_user_answers.joins(:question).where(collect_info_questions: {type_stage: 0})
  end

  def voted(user)
    self.voted_users.where(id: user)
  end

  def self.scope_vote_top(project, revers)
    includes(:final_votings).
        group('"core_aspect_posts"."id","collect_info_votings"."id"').
        where('"core_aspect_posts"."project_id" = ? and "core_aspect_posts"."status" = 0', project)
        .references(:collect_info_votings)
        .vote_top(revers)
  end

  def to_s
    self.content
  end

  def aspect_concept
    Concept::Post.joins(:concept_disposts).
        joins("INNER JOIN discontent_post_aspects ON concept_post_discontents.discontent_post_id = discontent_post_aspects.post_id").
        where("discontent_posts.status = ?", 4).
        where("discontent_post_aspects.aspect_id = ?", self.id)
  end

  def aspect_discontent
    Discontent::Post.joins(:post_aspects).where(discontent_post_aspects: {aspect_id: id})
  end

  def color
    color = read_attribute(:color)
    color.present? ? color : '#9d9d9d'
  end

  def rate_aspect
    project = self.project
    status = project.status > 6 ? 1 : 0
    count_all = project.discontents.by_status(status).count
    count_aspect = self.aspect_posts.by_status(status).count
    count_all == 0 ? 0 : ((count_aspect.to_f / count_all.to_f) * 100).round
  end


  # возвращает массив пар значений [аспект, уровень вложенности] последовательно начиная с переданного (корневого) аспекта
  def subaspects
    @@array_subaspects = []
    self.return_subaspect
    @@array_subaspects
  end

  # метод для возврата вложенного аспекта
  def return_subaspect(level = 0)
    @@array_subaspects.push([self, level])
    self.core_aspects.each { |asp| asp.return_subaspect(level+1) }
    return
  end
end
