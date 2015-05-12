class Plan::Post < ActiveRecord::Base
  include BasePost
  SCORE = 150
  belongs_to :user

  has_many :post_novations, foreign_key: 'plan_post_id', class_name: 'Plan::PostNovation'
  has_many :estimates, class_name: 'Estimate::Post'
  has_many :voted_users, through: :final_votings, source: :user
  has_many :final_votings, foreign_key: 'plan_post_id', class_name: 'Plan::Voting'
  # has_many :stages, class_name: 'Plan::PostStage'

  accepts_nested_attributes_for :post_novations

  def voted(user, type_vote)
    self.final_votings.where(user_id: user, type_vote: type_vote)
  end

  def vote_progress(type_vote)
    sum_all = self.final_votings.where(type_vote: type_vote).uniq.sum('plan_votings.status')
    count_all = self.final_votings.where(type_vote: type_vote).uniq.count
    count_all == 0 ? 0 : (sum_all.to_f/count_all.to_f).round
  end


  # def first_stage
  #   stages.first.id unless self.post_stages.first.nil?
  # end

  # def post_stages
  #   stages.where('plan_post_stages.status = ?', 0).order(:date_begin)
  # end
end
