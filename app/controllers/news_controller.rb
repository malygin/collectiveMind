class NewsController < ApplicationController
  # before_action :journal_data
  before_action :set_news, only: [:show, :edit, :update, :destroy, :read]
  before_action :set_project, only: [:read]
  before_action :set_logger, only: [:read]

  # GET /news
  def index
    @news = @project.news
  end

  # GET /news/1
  def show
  end

  # GET /news/new
  def new
    @news = News.new
  end

  # GET /news/1/edit
  def edit
  end

  # POST /news
  def create
    @news = @project.news.create(news_params)
    @news.user = current_user
    if @news.save
      redirect_to news_path(@project, @news), notice: 'News was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /news/1
  def update
    if @news.update(news_params)
      redirect_to news_path(@project, @news), notice: 'News was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /news/1
  def destroy
    @news.destroy
    redirect_to news_index_url, notice: 'News was successfully destroyed.'
  end

  def read
    head :ok
  end

  private

  def set_project
    @project = Core::Project.find(params[:project])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_news
    @news = News.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def news_params
    params.require(:news).permit(:title, :body)
  end

  # запись отдельного события для показа статуса новостей
  def set_logger
    return  unless current_user && @project && request.method == 'GET'
    current_user.loggers.create type_event: 'expert_news_read', project_id: @project.id,
                                body: request.original_fullpath.split('?')[0], first_id: @news.id
  end
end
