
class Concept::PostAspect < ActiveRecord::Base
  attr_accessible :discontent_aspect_id, :concept_post_id, :content, :control,
                  :name, :title, :negative, :positive, :reality, :problems, :positive_r, :negative_r

  belongs_to :concept_post, :class_name => 'Concept::Post', :foreign_key => :concept_post_id
  belongs_to :discontent, :class_name => 'Discontent::Post', :foreign_key => :discontent_aspect_id
  has_many :voted_users, :through => :final_votings, :source => :user
  has_many :final_votings, :foreign_key => 'concept_post_aspect_id', :class_name => 'Concept::Voting'

  def voted(user)
    self.voted_users.where(:id => user)
  end
  def not_vote_for_other_post_aspects(dis, user)
    dis.concept_conditions.each  do |asp|
      if asp.voted(user).size>0
        return false
      end
    end
    return true
  end

   def discontent_id
     self.discontent.id
   end


end
