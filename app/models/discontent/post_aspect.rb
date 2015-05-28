class Discontent::PostAspect < ActiveRecord::Base
  belongs_to :post, class_name: 'Discontent::Post'
  belongs_to :core_aspect, class_name: 'Core::Aspect::Post', foreign_key: :aspect_id

  validates :aspect_id, presence: true

  scope :by_aspect, ->(p) { where(aspect_id: p) }

  def to_s
    self.core_aspect.content
  end
end
