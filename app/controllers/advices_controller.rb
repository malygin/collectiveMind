class AdvicesController < ApplicationController
  before_action :set_discontent_post_advice, only: [:show, :edit, :update, :destroy, :approve]
  before_action :set_discontent_post, except: [:index, :destroy, :show, :approve]
  before_action :journal_data
  before_filter :only_moderators, only: [:index, :show, :approve]

  def index
    @unapproved_advices = Advice.unapproved
  end

  # GET /discontent/post_advices/1
  def show
    @advice_comment = AdviceComment.new
  end

  # GET /discontent/post_advices/1/edit
  def edit
  end

  # POST /discontent/post_advices
  def create
    @advice = @post.advices.new advice_params
    @advice.user = current_user
    @advice.save
    respond_to do |format|
      format.js
    end
  end

  # PATCH/PUT /discontent/post_advices/1
  def update
    if @advice.update(advice_params)
      redirect_to @advice, notice: 'Post advice was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /discontent/post_advices/1
  def destroy
    @advice.destroy
    redirect_to discontent_advices_url(@project), notice: 'Post advice was successfully destroyed.'
  end

  def approve
    @advice.update_attributes! approved: true
  end

  private
  def only_moderators
    redirect_back_or root_url unless current_user.admin?
  end

  private
  def set_discontent_post
    @post = Discontent::Post.find params[:discontent_id] if params[:discontent_id]
    @post = Concept::Post.find params[:concept_id] if params[:concept_id]
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_discontent_post_advice
    @advice = Advice.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def advice_params
    params.require(:advice).permit(:content)
  end
end
