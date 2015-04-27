class Novation::PostsController < PostsController
  include Novation::PostsHelper
  include CloudinaryHelper
  before_action :set_novation_post, only: [:edit, :update]

  def index
    @posts= nil
    @posts = @project.novations.created_order
    respond_to do |format|

      format.html # show.html.erb
      format.json { render json: @posts.each_with_index.map { |item, index| {id: item.id, index: index+1, title: item.title, content: trim_post_content(item.content, 100),
                                                                             user: item.user.to_s, user_avatar: item.user.try(:avatar) ? cl_image_path(item.user.try(:avatar))  : ActionController::Base.helpers.asset_path('no-ava.png') , post_date: Russian::strftime(item.created_at, '%d.%m.%Y'),
                                                                             project_id: item.project_id, sort_date: item.created_at.to_datetime.to_f, sort_comment: item.last_comment.present? ? item.last_comment.created_at.to_datetime.to_f : 0,
                                                                             concept_class: post_concept_classes(item),
                                                                             count_comments: item.comments.count,
                                                                             count_likes: item.users_pro.count,
                                                                             count_dislikes: item.users_against.count,
                                                                             concepts: item.novation_concepts.map { |concept| {id: concept.id, content: trim_post_content(concept.content, 30)} },
                                                                             comments: item.comments.preview.map { |comment| {id: comment.id, date: Russian::strftime(comment.created_at, '%k:%M %d.%m.%y'), user: comment.user.to_s, content: trim_post_content(comment.content, 50)} }} } }

    end
  end

  def new
    @novation = current_model.new
  end

  def edit
  end

  def create
    @novation = current_model.new(novation_params)

    if @novation.save
      redirect_to @novation, notice: 'Novation was successfully created.'
    else
      render :new
    end
  end

  def update
    if @novation.update(novation_params)
      redirect_to @novation, notice: 'Novation was successfully updated.'
    else
      render :edit
    end
  end


  private
    def set_novation_post
      @novation = current_model.find(params[:id])
    end

    def novation_params
      params.require(:novation_post).permit(:title, :user_id, :number_views, :status, :project_id, :actions_desc, :actions_ground, :actors, :tools, :impact_group, :impact_env)
    end
end
