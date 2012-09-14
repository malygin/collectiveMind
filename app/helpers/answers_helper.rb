module AnswersHelper
	def answer_allow_vote?(answer)
    	not answer.users.include?(current_user) and signed_in?
	end
end
