module AnswersHelper
	def answer_allow_vote?(answer)
    	not answer.users.include?(current_user)
	end
end
