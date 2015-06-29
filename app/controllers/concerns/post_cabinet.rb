module PostCabinet
  extend ActiveSupport::Concern
  included do
    before_filter :check_type_mechanics, only: [:new, :edit, :user_content]
    before_filter :check_stage_for_cabinet, only: [:new, :edit, :user_content]
  end

  def new
    @post = current_model.new
    respond_to :html
  end

  def edit
    @post = current_model.find(params[:id])
  end

  def create
    @post = current_model.create_post(params, @project, current_user)
    respond_to :html, :js
  end

  def update
    @post = current_model.find(params[:id])
    respond_to do |format|
      if @post.update_attributes(params[name_of_model_for_param])
        format.html { redirect_to action: 'show', project: @project, id: @post.id }
        format.js
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    @post = current_model.find(params[:id]).destroy
    respond_to do |format|
      format.html { redirect_to current_stage_url(@project) }
      format.json { head :no_content }
    end
  end

  def user_content
    @content = current_model.by_project(@project).by_user(current_user)
    @stage_comments = comment_model.by_user(current_user).stage_comments_for(@project)
  end

  def publish
    @post = current_model.find params[:id]
    @post.update status: current_model::STATUSES[:published]
  end

  private

  def check_stage_for_cabinet
    #  check if user reload url for old-stage cabinet, and procedure on new stage - redirect to new stage
    return if @project.current_stage_type == params[:controller].sub('/', '_').to_sym || action_name == 'user_content'
    redirect_to url_for(params.merge(controller: '/' + @project.current_stage_type.to_s.sub('_', '/')))
  end

  def check_type_mechanics
    # check if we use possible mechanic or use default
    if params[:type_mechanic].present? && correct_mechanic?
      @mechanic_type = params[:type_mechanic]
    else
      @mechanic_type = 'simple'
    end
  end

  def correct_mechanic?
    Technique::List.by_stage(current_model.to_s.sub('::', '_').underscore.pluralize).where(code: params[:type_mechanic]).any?
  end
end
