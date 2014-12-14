class Plan::Post < ActiveRecord::Base
  include BasePost

  has_many :post_aspects, foreign_key: 'plan_post_id', class_name: 'Plan::PostAspect'
  scope :post_aspects_first, -> { joins(:post_aspects).where('post_aspects.first_stage = ?', 1) }
  scope :post_aspects_other, -> { joins(:post_aspects).where('post_aspects.first_stage = ?', 0) }

  has_many :estimates, class_name: 'Estimate::Post'
  has_many :voted_users, through: :final_votings, source: :user
  has_many :final_votings, foreign_key: 'plan_post_id', class_name: 'Plan::Voting'

  has_many :post_st, class_name: 'Plan::PostStage'
  scope :by_project, ->(p) { where(project_id: p) }

  def voted(user)
    self.voted_users.where(id: user)
  end

  def get_pa_by_discontent(d, column, first = 0)
    self.post_aspects.where(discontent_aspect_id: d, first_stage: first).first.send(column) unless self.post_aspects.empty?
  end

  def first_stage
    self.post_stages.first.id unless self.post_stages.first.nil?
  end

  def post_stages
    post_st.where('plan_post_stages.status = ?', 0).order(:date_begin)
  end
end
