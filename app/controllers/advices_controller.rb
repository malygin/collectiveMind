class AdvicesController < ApplicationController
  before_action :set_discontent_post_advice, only: [:edit, :update, :destroy, :approve]
  before_action :set_discontent_post, except: [:index, :destroy, :approve]
  before_action :journal_data
  before_filter :only_moderators, only: [:index, :approve]

  def index
    @unapproved_advices = Advice.unapproved
  end

  # GET /discontent/post_advices/1/edit
  def edit
    respond_to do |format|
      format.js
    end
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
    @advice.update(advice_params)
    respond_to do |format|
      format.js
    end
  end

  # DELETE /discontent/post_advices/1
  def destroy
    @advice.destroy
    redirect_to discontent_advices_url(@project), notice: 'Post advice was successfully destroyed.'
  end

  def approve
    @advice.update_attributes! approved: true
    current_user.journals.build(type_event: 'advice_approve', body: trim_content(@advice.content),
                                first_id: @advice.id, project: @project).save!
    current_user.add_score(type: :approve_advice)
    current_user.journals.build(type_event: 'my_advice_approved', project: @project,
                                body: "#{trim_content(@advice.content)}",
                                first_id: @advice.id, personal: true, viewed: false).save!
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
