class AdviceCommentsController < ApplicationController
  before_action :journal_data
  before_action :set_advice, only: [:new, :create]

  def new
    @advice_comment = AdviceComment.new
    @main_comment = AdviceComment.find params[:comment_id]
    @advice_comment.post_advice_comment_id = @main_comment.id
  end

  # POST /discontent/post_advice_comments
  def create
    @advice_comment = @discontent_advice.comments.new(advice_comment_params)
    @advice_comment.user = current_user
    @advice_comment.save
    respond_to do |format|
      format.js
    end
  end

  # DELETE /discontent/post_advice_comments/1
  def destroy
    @advice_comment = AdviceComment.find(params[:id])
    @advice_comment.destroy
    respond_to do |format|
      format.js
    end
  end

  private
  def set_advice
    @discontent_advice = Advice.find params[:advice_id]
  end

  # Only allow a trusted parameter "white list" through.
  def advice_comment_params
    params.require(:advice_comment).permit(:content, :post_advice_comment_id)
  end
end
