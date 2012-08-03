class CommentFrustrationsController < ApplicationController
  def create
    @frustration = Frustration.find(params[:frustration_id])
    @comment = @frustration.comment_frustrations.create(:user_id => current_user.id, :content =>params[:comment_frustration][:content])
    redirect_to frustration_path(@frustration)
  end

  def destroy
  end
end
