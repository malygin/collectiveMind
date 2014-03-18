module Concept::PostsHelper
	def can_vote_for_task?(task)
		task.voitings.each do |fr|
			if fr.user == current_user	
				return false
			end
		end
		return true
  end


end
