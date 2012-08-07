class FrustrationCommentsController < ApplicationController
  def create
    @frustration = Frustration.find(params[:frustration_id])
    #puts "_________"
    #puts params[:negative]
    @comment = @frustration.frustration_comments.create(:user_id => current_user.id, :content =>params[:frustration_comment][:content],  :negative => params[:negative])
    redirect_to frustration_path(@frustration)
  end

  def destroy
  end
end
