class Help::Answer < ActiveRecord::Base
  attr_accessible :content, :order, :question_id
end
