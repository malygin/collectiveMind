class Novation::Post < ActiveRecord::Base
  include BasePost

  has_many :voted_users, through: :final_votings, source: :user
  has_many :final_votings, foreign_key: 'novation_post_id', class_name: 'Novation::Voting'

  has_many :novation_post_concepts, class_name: 'Novation::PostConcept'
  has_many :novation_concepts, through: :novation_post_concepts, source: :concept_post, class_name: 'Concept::Post'


  validates :status, presence: true

  scope :by_status, ->(p) { where(status: p) }
  scope :by_project, ->(p) { where(project_id: p) }


end
