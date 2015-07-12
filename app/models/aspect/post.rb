class Aspect::Post < ActiveRecord::Base
  include BasePost
  SCORE = 20

  belongs_to :aspect, class_name: 'Aspect::Post', foreign_key: 'aspect_id'
  has_many :aspects, class_name: 'Aspect::Post', foreign_key: 'aspect_id'

  has_many :discontent_post_aspects, class_name: 'Discontent::PostAspect', foreign_key: :aspect_id

  has_many :aspect_posts, through: :discontent_post_aspects, source: :post, class_name: 'Discontent::Post'
  # для связи с постами следующего уровня
  has_many :related_next_posts, through: :discontent_post_aspects, source: :post, class_name: 'Discontent::Post'

  has_many :knowbase_posts, class_name: 'Core::Knowbase::Post', foreign_key: :aspect_id

  has_many :voted_users, through: :final_votings, source: :user
  has_many :final_votings, foreign_key: 'aspect_id', class_name: 'Aspect::Voting'

  has_many :aspect_user_answers, class_name: 'Aspect::UserAnswer', foreign_key: 'aspect_id'
  has_many :questions, -> { where status: 0 }, class_name: 'Aspect::Question', foreign_key: 'aspect_id'

  validates :content, presence: true

  default_scope { order :id }
  scope :main_aspects, -> { where(aspect_posts: { aspect_id: nil }) }

  # выборка всех вопросов к аспекту на которые пользователь еще не ответил
  # @todo for Daniil refac same with votings
  def missed_questions(user, type_questions)
    questions_answered = questions.by_type(type_questions).joins(:user_answers)
                         .where(aspect_user_answers: { user_id: user.id }).pluck('aspect_questions.id')
    questions.by_type(type_questions).where.not(id: questions_answered)
  end

  def to_s
    content
  end
end
