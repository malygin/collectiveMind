class Concept::Post < ActiveRecord::Base
  include BasePost
  SCORE = 70

  has_many :voted_users, through: :final_votings, source: :user
  has_many :final_votings, foreign_key: 'concept_post_id', class_name: 'Concept::Voting'

  has_many :concept_post_discontents, class_name: 'Concept::PostDiscontent'
  has_many :concept_disposts, through: :concept_post_discontents, source: :discontent_post, class_name: 'Discontent::Post'

  validates :title, presence: true
end
