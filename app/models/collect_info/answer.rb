class CollectInfo::Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  scope :by_status, ->(status) { where(collect_info_answers: {status: status}) }
  scope :by_style, ->(style) { where(collect_info_answers: {style: style}) }

  validates :content, :question_id, :style, presence: true
end