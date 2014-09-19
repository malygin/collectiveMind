class LifeTape::Post < ActiveRecord::Base
  include BasePost

  has_many :life_tape_post_discussions, class_name: 'LifeTape::PostDiscussion'
  has_many :post_discussion_users, through: :life_tape_post_discussions, source: :user, class_name: 'User'
  belongs_to :aspect, class_name: 'Discontent::Aspect', foreign_key: 'aspect_id'
  has_and_belongs_to_many :discontent_aspects, class_name: 'Discontent::Aspect',
                          join_table: 'discontent_aspects_life_tape_posts', foreign_key: 'life_tape_post_id',
                          association_foreign_key: 'discontent_aspect_id'

  scope :by_project, ->(p) { where(project_id: p) }
  scope :by_discussions, ->(posts) { where("life_tape_posts.id NOT IN (#{posts.join(', ')})") unless posts.empty? }
end
