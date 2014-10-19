class AdviceCommentsController < ApplicationController
  before_action :journal_data
  before_action :set_advice, only: [:new, :create]

  def new
    @advice_comment = AdviceComment.new
    #respond_to do |format|
  end

  # POST /discontent/post_advice_comments
  def create
    @advice_comment = @advice.comments.new(advice_comment_params)
    @advice_comment.user = current_user
    @advice_comment.save
    unless current_user?(@advice.user)
      current_user.journals.build(type_event: 'my_advice_commented', project: @project,
                                  user_informed: @advice.user,
                                  body: "#{trim_content(@advice.content)}",
                                  first_id: @advice.id, personal: true, viewed: false).save!
    end
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
    @advice = Advice.find params[:advice_id]
  end

  # Only allow a trusted parameter "white list" through.
  def advice_comment_params
    params.require(:advice_comment).permit(:content)
  end
end
