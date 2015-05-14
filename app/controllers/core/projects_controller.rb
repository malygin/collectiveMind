class Core::ProjectsController < ApplicationController
  before_filter :prime_admin_authenticate, only: [:next_stage, :pr_stage, :show, :new, :edit, :create, :update, :destroy, :index,
                                                  :general_analytics, :lifetape_analytics, :discontent_analytics, :concept_analytics, :plan_analytics, :estimate_analytics]
  before_filter :project_by_id
  before_action :set_core_project, only: [:show, :edit, :update, :pr_stage, :next_stage, :destroy]
  before_filter :boss_news_authenticate, only: [:news, :users]
  after_filter :last_seen_news, only: [:news]
  layout 'application', only: [:news, :users, :general_analytics, :lifetape_analytics, :discontent_analytics, :concept_analytics, :plan_analytics, :estimate_analytics]

  def project_by_id
    unless params[:project].nil?
      @core_project = Core::Project.find(params[:project])
    end
  end

  def index
    @view_projects = Core::Project.where(type_access: list_type_projects_for_user)
    @core_project = @view_projects.first

    respond_to do |format|
      format.html { render layout: 'core/projects' }
    end
  end

  def show
    @project = Core::Project.find(params[:id])
    redirect_to polymorphic_path(@project.current_stage_type, project: @project)
  end

  def new
    @project = Core::Project.new
    @core_project = Core::Project.all.last

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @core_project }
    end
  end

  def edit
    @project = Core::Project.find(params[:id])
  end

  def create
    @project = Core::Project.new(core_project_params)

    if @project.save
      @project.project_users.create user_id: current_user.id, owner: true
      redirect_to edit_core_project_path(@project), success: 'Project was successfully created.'
    else
      render action: :new
    end
  end

  def update
    respond_to do |format|
      if @core_project.update_attributes(core_project_params)
        format.html { redirect_to core_projects_path, success: 'Процедура успешно отредактирована' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @core_project.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @core_project.update_attributes(type_access: 10)

    respond_to do |format|
      format.html { redirect_to core_projects_url }
      format.json { head :no_content }
    end
  end

  def next_stage
    @project = @core_project
    @project.settings.stage_dates[@project.status.to_s]['real']['end'] = Date.today
    @project.status = @project.status + 1
    @project.settings.stage_dates[@project.status.to_s]['real']['start'] = Date.today
    @project.settings.stage_dates_will_change!
    @project.save
    @project.set_position_for_aspects if @project.status == 3
    @project.set_date_for_stage
    respond_to do |format|
      format.js { render 'update_stage' }
      format.html { redirect_to "/project/#{@project.id}" }
    end
  end

  def pr_stage
    @project = @core_project
    @project.settings.stage_dates[@project.status.to_s]['real']['start'] = ''
    @project.status = @project.status - 1
    @project.settings.stage_dates[@project.status.to_s]['real']['end'] = ''
    @project.save
    respond_to do |format|
      format.js { render 'update_stage' }
      format.html { redirect_to "/project/#{@project.id}" }
    end
  end

  def news
    @project = Core::Project.find(params[:project]) if params[:project]
    @core_projects = current_user.current_projects_for_journal
    @core_project = @core_projects.first

    if @project
      if @project.project_access(current_user)
        @journals_feed_all = Journal.filter(filtering_params(params)).events_for_project(@project.id).where(journals: {visible: true}).paginate(page: params[:page])
      end
    elsif prime_admin?
      @journals_feed_all = Journal.filter(filtering_params(params)).events_for_all_prime.where(journals: {visible: true}).paginate(page: params[:page])
    else
      closed_projects = current_user.projects.where(core_projects: {type_access: 2}).active_proc.pluck("core_projects.id")
      @journals_feed_all = Journal.filter(filtering_params(params)).events_for_all(list_type_projects_for_user, closed_projects == [] ? [-1] : closed_projects).where(journals: {visible: true}).paginate(page: params[:page])
    end
    @j_count = {today: 0, yesterday: 0, older: 0}
    @users_for_news = User.where("name != ? OR surname != ?", '', '').order(:id)
  end

  def users
    @project = Core::Project.find(params[:project]) if params[:project]
    @core_projects = current_user.current_projects_for_user
    @core_project = @core_projects.first
    if @project
      if @project.type_access == 2
        @users = @project.users_in_project.includes(:core_project_scores).where(users: {type_user: uniq_proc_users}).order("core_project_scores.score DESC NULLS LAST").paginate(page: params[:page])
      else
        @users = User.joins(:core_project_scores).where("core_project_scores.project_id = ? AND core_project_scores.score > 0", @project.id).where(users: {type_user: uniq_proc_users}).order("core_project_scores.score DESC").paginate(page: params[:page])
      end
    else
      @users = User.where(type_user: uniq_proc_users).order("score DESC").paginate(page: params[:page])
    end
  end

  def general_analytics
    @project = Core::Project.find(params[:project]) if params[:project]
    @core_projects = current_user.current_projects_for_user
    @core_project = @core_projects.first
  end

  def lifetape_analytics
    @project = Core::Project.find(params[:project]) if params[:project]
    @core_projects = current_user.current_projects_for_user
    @core_project = @core_projects.first
  end

  def discontent_analytics
    @project = Core::Project.find(params[:project]) if params[:project]
    @core_projects = current_user.current_projects_for_user
    @core_project = @core_projects.first
  end

  def concept_analytics
    @project = Core::Project.find(params[:project]) if params[:project]
    @core_projects = current_user.current_projects_for_user
    @core_project = @core_projects.first
  end

  def plan_analytics
    @project = Core::Project.find(params[:project]) if params[:project]
    @core_projects = current_user.current_projects_for_user
    @core_project = @core_projects.first
  end

  def estimate_analytics
    @project = Core::Project.find(params[:project]) if params[:project]
    @core_projects = current_user.current_projects_for_user
    @core_project = @core_projects.first
  end

  def graf_data
    @project = Core::Project.find(params[:project]) if params[:project]
    hash_base = [{x: (Date.parse("2000-01-01").to_datetime.to_f * 1000).to_i, y: 0}, {x: (Date.parse("2000-01-02").to_datetime.to_f * 1000).to_i, y: 0}, {x: (Date.parse("2000-01-03").to_datetime.to_f * 1000).to_i, y: 0},
                 {x: (Date.parse("2000-01-04").to_datetime.to_f * 1000).to_i, y: 0}, {x: (Date.parse("2000-01-05").to_datetime.to_f * 1000).to_i, y: 0}]

    if params[:data_stage] == "concept_analytics"
      data_content = @project.concept_ongoing_post.date_stage(@project).order("concept_posts.created_at").pluck("concept_posts.id", "date(concept_posts.created_at)")
      data_comment = @project.concept_comments.date_stage(@project).reorder("concept_comments.created_at").pluck("concept_comments.id", "date(concept_comments.created_at)")
      data_content = data_content.map { |d| d[1] }.group_by { |i| i }.map { |k, v| {x: (k.to_datetime.to_f * 1000).to_i, y: v.count} }
      data_comment = data_comment.map { |d| d[1] }.group_by { |i| i }.map { |k, v| {x: (k.to_datetime.to_f * 1000).to_i, y: v.count} }
      data_content = hash_base | data_content if data_content.size < 5
      data_comment = hash_base | data_comment if data_comment.size < 5
      data = [{key: "Нововведения", values: data_content}, {key: "Комментарии", values: data_comment}]
    elsif params[:data_stage] == "discontent_analytics"
      data_content = @project.discontents.by_status(@project.status > 4 ? 1 : 0).date_stage(@project).order("discontent_posts.created_at").pluck("discontent_posts.id", "date(discontent_posts.created_at)")
      data_comment = @project.discontent_comments.date_stage(@project).reorder("discontent_comments.created_at").pluck("discontent_comments.id", "date(discontent_comments.created_at)")
      data_content = data_content.map { |d| d[1] }.group_by { |i| i }.map { |k, v| {x: (k.to_datetime.to_f * 1000).to_i, y: v.count} }
      data_comment = data_comment.map { |d| d[1] }.group_by { |i| i }.map { |k, v| {x: (k.to_datetime.to_f * 1000).to_i, y: v.count} }
      data_content = hash_base | data_content if data_content.size < 5
      data_comment = hash_base | data_comment if data_comment.size < 5
      data = [{key: "Несовершенства", values: data_content}, {key: "Комментарии", values: data_comment}]
    elsif params[:data_stage] == "lifetape_analytics"
      data_comment = @project.lifetape_comments.date_stage(@project).reorder("life_tape_comments.created_at").pluck("life_tape_comments.id", "date(life_tape_comments.created_at)")
      data_comment = data_comment.map { |d| d[1] }.group_by { |i| i }.map { |k, v| {x: (k.to_datetime.to_f * 1000).to_i, y: v.count} }
      data_comment = hash_base | data_comment if data_comment.size < 5
      data = [{key: "Комментарии", values: data_comment}]
    end
    render json: data
  end

  private
  def last_seen_news
    current_user.update_attributes(last_seen_news: Time.zone.now.utc) if current_user and boss?
  end

  def set_core_project
    @core_project = Core::Project.find(params[:id])
  end

  def core_project_params
    params.require(:core_project).permit(:name, :type_access, :short_desc, :desc, :code, :color,
                                         :date_start, :date_end, :count_stages, :project_type_id)
  end

  def filtering_params(params)
    params.slice(:type_content, :type_event, :type_status, :select_users_for_news, :date_begin, :date_end)
  end
end
