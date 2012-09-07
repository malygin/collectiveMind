# encoding: utf-8
class FrustrationCommentsController < ApplicationController
  def create
    @frustration = Frustration.find(params[:frustration_id])
    #puts "_________"
    #puts params[:negative]
    @comment = @frustration.frustration_comments.create(:user_id => current_user.id, :content =>params[:frustration_comment][:content],  :negative => params[:negative])
    redirect_to frustration_path(@frustration)
  end

  def to_trash_by_admin
  	#puts params
  	@comment = FrustrationComment.find(params[:id])
  	if to_bool(params[:del])
      @comment.user.update_column(:score, @comment.user.score + Settings.scores.unstructure.violation_comment )
  	end
    @comment.update_column(:trash, true)
  	flash[:success] = "Комментарий удален!"
  	redirect_to frustration_path(params[:frustration_id])
  end

  def destroy
  end
end
