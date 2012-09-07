module QuestionsHelper
	def allow_vote?(question)
    	not question.users.include?(current_user)
	end
end
