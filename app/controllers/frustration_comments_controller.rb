# encoding: utf-8
class FrustrationCommentsController < ApplicationController
  def create
    puts params
    @frustration = Frustration.find(params[:frustration_id])
    unless params[:frustration_comment][:comment_id].nil?
      frustration_comment = FrustrationComment.find(params[:frustration_comment][:comment_id])
      @comment = @frustration.frustration_comments.create(:user_id => current_user.id, :frustration_comment =>frustration_comment, :content =>params[:frustration_comment][:content],  :negative => params[:negative])
    else
      @comment = @frustration.frustration_comments.create(:user_id => current_user.id, :content =>params[:frustration_comment][:content],  :negative => params[:negative])
    end
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
