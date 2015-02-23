class Plan::Post < ActiveRecord::Base
  include BasePost
  belongs_to :user

  has_many :post_aspects, foreign_key: 'plan_post_id', class_name: 'Plan::PostAspect'
  has_many :estimates, class_name: 'Estimate::Post'
  has_many :voted_users, through: :final_votings, source: :user
  has_many :final_votings, foreign_key: 'plan_post_id', class_name: 'Plan::Voting'
  has_many :post_st, class_name: 'Plan::PostStage'

  scope :by_project, ->(p) { where(project_id: p) }

  validates :project_id, :user_id, :status, presence: true

  def voted(user)
    self.voted_users.where(id: user)
  end


  def first_stage
    self.post_stages.first.id unless self.post_stages.first.nil?
  end

  def post_stages
    post_st.where('plan_post_stages.status = ?', 0).order(:date_begin)
  end
end
