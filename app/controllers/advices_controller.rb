class AdvicesController < ApplicationController
  before_action :journal_data
  before_action :set_advice, except: [:index]
  before_filter :only_moderators, only: [:index, :approve]
  before_filter :only_author_of_post, only: [:useful, :not_useful]

  def index
    @unapproved_advices = Advice.unapproved
  end

  # GET /discontent/post_advices/1/edit
  def edit
    respond_to do |format|
      format.js
    end
  end

  # PATCH/PUT /discontent/post_advices/1
  def update
    @advice.update(advice_params.merge(approved: nil))
    @advice.notify_moderators(@project, current_user)
    respond_to do |format|
      format.js
    end
  end

  # DELETE /discontent/post_advices/1
  def destroy
    @advice.destroy
    redirect_back_or polymorphic_path(@advice.adviseable, project: @project)
  end

  def approve
    @advice.update_attributes! approved: true
    @advice.user.journals.build(type_event: 'advice_approve', body: trim_content(@advice.content),
                                first_id: @advice.id, project: @project).save!
    @advice.user.add_score(type: :approve_advice)
    current_user.journals.build(type_event: 'my_advice_approved', project: @project,
                                user_informed: @advice.user,
                                body: "#{trim_content(@advice.content)}",
                                first_id: @advice.id, personal: true, viewed: false).save!
    current_user.journals.build(type_event: 'my_post_adviseable', project: @project,
                                user_informed: @advice.adviseable.user,
                                body: "#{trim_content(@advice.content)}",
                                first_id: @advice.id, personal: true, viewed: false).save!
  end

  def not_approve
    @advice.update_attributes! approved: false
    current_user.journals.build(type_event: 'my_advice_disapproved', project: @project,
                                user_informed: @advice.user,
                                body: "#{trim_content(@advice.content)}",
                                first_id: @advice.id, personal: true, viewed: false).save!
  end

  def useful
    @advice.update_attributes! useful: true
    @advice.user.add_score(type: :useful_advice)
    current_user.journals.build(type_event: 'my_advice_useful', project: @project,
                                user_informed: @advice.user,
                                body: "#{trim_content(@advice.content)}",
                                first_id: @advice.id, personal: true, viewed: false).save!
    respond_to do |format|
      format.js { render action: 'update' }
    end
  end

  def not_useful
    @advice.update_attributes! useful: false
    respond_to do |format|
      format.js { render action: 'update' }
    end
  end

  private
  def only_author_of_post
    redirect_back_or project_path(@project) unless current_user?(@advice.adviseable.user)
  end

  def only_moderators
    redirect_back_or root_url unless current_user.admin?
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_advice
    @advice = Advice.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def advice_params
    params.require(:advice).permit(:content)
  end
end
