class Core::Aspect::Comment < ActiveRecord::Base
  include BaseComment

  belongs_to :answer, class_name: 'CollectInfo::Answer', foreign_key: 'answer_id'
end
