class Discontent::PostAdviceCommentsController < ApplicationController
  before_action :set_discontent_post_advice_comment, only: [:destroy]

  # GET /discontent/post_advice_comments/new
  def new
    @discontent_post_advice_comment = Discontent::PostAdviceComment.new
  end

  # POST /discontent/post_advice_comments
  def create
    @discontent_post_advice_comment = Discontent::PostAdviceComment.new(discontent_post_advice_comment_params)

    if @discontent_post_advice_comment.save
      redirect_to @discontent_post_advice_comment, notice: 'Post advice comment was successfully created.'
    else
      render :new
    end
  end

  # DELETE /discontent/post_advice_comments/1
  def destroy
    @discontent_post_advice_comment = Discontent::PostAdviceComment.find(params[:id])
    @discontent_post_advice_comment.destroy
    redirect_to discontent_post_advice_comments_url, notice: 'Post advice comment was successfully destroyed.'
  end

  private
  # Only allow a trusted parameter "white list" through.
  def discontent_post_advice_comment_params
    params.require(:discontent_post_advice_comment).permit(:content, :post_advice_comment_id)
  end
end
