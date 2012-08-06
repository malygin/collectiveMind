class FrustrationCommentsController < ApplicationController
  def create
    @frustration = Frustration.find(params[:frustration_id])
    @comment = @frustration.frustration_comments.create(:user_id => current_user.id, :content =>params[:frustration_comment][:content])
    redirect_to frustration_path(@frustration)
  end

  def destroy
  end
end
