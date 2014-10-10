class Discontent::PostAdvicesController < ApplicationController
  before_action :set_discontent_post_advice, only: [:show, :edit, :update, :destroy, :approve]
  before_action :set_discontent_post, except: [:index, :destroy, :show]
  before_action :journal_data
  before_filter :only_moderators, only: [:index, :show, :approve]

  def index
    @unapproved_advices = Discontent::PostAdvice.unapproved
  end

  # GET /discontent/post_advices/1
  def show
  end

  # GET /discontent/post_advices/1/edit
  def edit
  end

  # POST /discontent/post_advices
  def create
    @discontent_post_advice = current_user.discontent_post_advices.new discontent_post_advice_params
    @discontent_post_advice.discontent_post = @post
    @discontent_post_advice.save
    respond_to do |format|
      format.js
    end
  end

  # PATCH/PUT /discontent/post_advices/1
  def update
    if @discontent_post_advice.update(discontent_post_advice_params)
      redirect_to @discontent_post_advice, notice: 'Post advice was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /discontent/post_advices/1
  def destroy
    @discontent_post_advice.destroy
    redirect_to discontent_post_advices_url(@project), notice: 'Post advice was successfully destroyed.'
  end

  def approve
    @discontent_post_advice.update_attribute approved: true
  end

  private
  def only_moderators
    redirect_back_or root_url unless current_user.admin?
  end

  private
  def set_discontent_post
    @post = Discontent::Post.find params[:post_id]
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_discontent_post_advice
    @discontent_post_advice = Discontent::PostAdvice.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def discontent_post_advice_params
    params.require(:discontent_post_advice).permit(:content)
  end
end
