 class Concept::Post < ActiveRecord::Base
  include BasePost
  attr_accessible :goal, :reality,
                  :stat_name, :stat_content, :stat_negative, :stat_positive, :stat_reality, :stat_problems, :stat_positive_r, :stat_negative_r

  belongs_to :life_tape_post,  :class_name => "LifeTape::Post"
  has_many :task_supply_pairs
  has_many :post_aspects, :foreign_key => 'concept_post_id', :class_name => "Concept::PostAspect"

  has_many :voted_users, :through => :final_votings, :source => :user
  has_many :final_votings,:foreign_key => 'concept_post_id', :class_name => "Concept::Voting"

  has_many :concept_notes, :class_name => 'Concept::Note'

  scope :stat_fields_negative, ->(p){where(:id => p).where("stat_name = 'f' or stat_content = 'f' or stat_negative = 'f'
            or stat_positive = 'f' or stat_reality = 'f' or stat_problems = 'f'
            or stat_positive_r = 'f' or stat_negative_r = 'f' ")}
  scope :stat_fields_positive, ->(p){where(:id => p).where("stat_name = 't' and stat_content = 't' and stat_negative = 't'
            and stat_positive = 't' and stat_reality = 't' and stat_problems = 't'
            and stat_positive_r = 't' and stat_negative_r = 't' ")}

  def post_notes(type_field)
    self.concept_notes.by_type(type_field)
  end
  def note_size?(type_fd)
    self.post_notes(type_fd).size > 0
  end

  def content
     self.post_aspects.first.content
  end

  def resource

  end
end
