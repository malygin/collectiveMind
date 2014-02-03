class Help::Question < ActiveRecord::Base
  attr_accessible :content, :order, :post_id, :style
end
