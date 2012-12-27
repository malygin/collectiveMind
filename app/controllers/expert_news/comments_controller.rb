class ExpertNews::CommentsController < ApplicationController	
  def plus
  	comment = ExpertNews::Comment.find(params[:id])
  	comment.comment_voitings.create(:user => current_user, :comment => comment)
    render json:comment.users.count 
  end
end
