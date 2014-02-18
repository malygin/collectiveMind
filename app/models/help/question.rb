class Help::Question < ActiveRecord::Base
  attr_accessible :content, :order, :post_id, :style
  belongs_to :post, :class_name => 'Help::Post'
  has_many :help_answers, :class_name => 'Help::Answer'
end
