class Plan::CommentsController < ApplicationController	
  def plus
  	comment = Plan::Comment.find(params[:id])
  	comment.comment_voitings.create(:user => current_user, :comment => comment)
    render json:comment.users.count 
  end
end
