module DiscontentGroup
  extend ActiveSupport::Concern

  included do
    attr_reader :discontent_post
    before_action :set_aspects, only: [:new_group, :edit_group]
    before_action :set_accepted_posts, only: [:create_group, :union_group, :update_group]
  end

  #методы REST group
  module ClassMethods

    def new_group
      @asp = Core::Aspect::Post.find(params[:asp]) if params[:asp]
      @post_group = Discontent::PostGroup.new
      respond_to do |format|
        format.js
      end
    end

    def edit_group
      @asp = Core::Aspect::Post.find(params[:asp]) if params[:asp]
      @post_group = Discontent::PostGroup.find(params[:id])
      @aspects_for_post = @post_group.post_group_aspects
      respond_to do |format|
        format.js
      end
    end

    def create_group
      @post_group = @project.discontent_groups.build(discontent_post_group_params)
      if params[:discontent_post_aspects]
        params[:discontent_post_aspects].each do |asp|
          @post_group.discontent_post_group_aspects.build(aspect_id: asp.to_i)
        end
      end
      if @post_group.save
        respond_to do |format|
          format.js
        end
      end
    end

    def update_group
      @post_group = Discontent::PostGroup.find(params[:id])
      if params[:discontent_post_aspects]
        @post_group.update_status_fields(discontent_post_group_params)
        @post_group.update_attributes(discontent_post_group_params)
        @post_group.update_post_aspects(params[:discontent_post_aspects])
      end
      respond_to do |format|
        format.js
      end
    end

    def destroy_group
      @post_group = Discontent::PostGroup.find(params[:id])
      if @post_group.discontent_posts.present?
        @post_group.discontent_posts.each do |post|
          post.update_attributes(status: 0, discontent_post_id: nil)
        end
      end
      @post_group.update_column(:status, 3)
      redirect_to action: 'index'
    end



    #добавление в группу
    def union_group
      @post = Discontent::Post.find(params[:id])
      @post_group = Discontent::PostGroup.find(params[:group_id])
      if @post && @post_group
        @post.update_attributes(status: 1, discontent_post_id: @post_group.id)
        @post_group.update_union_post_aspects(@post.post_aspects)
      end
      respond_to do |format|
        format.js
      end
    end

    #объединение в группу
    def union_discontent
      @post = Discontent::Post.find(params[:id])
      @post_group = @project.discontent_groups.create(style: @post.style, content: params[:union_post_descr], whered: @post.whered, whend: @post.whend)
      if params[:posts]
        params[:posts].each do |p|
          post = Discontent::Post.find(p)
          post.update_attributes(status: 1, discontent_post_id: @post_group.id)
          @post_group.update_union_post_aspects(post.post_aspects)
        end
      end
      @post.update_attributes(status: 1, discontent_post_id: @post_group.id)
      @post_group.update_union_post_aspects(@post.post_aspects)
      redirect_to discontent_post_path(@project, @post_group)
    end

    #удаление из группы
    def remove_union
      @post_group = Discontent::PostGroup.find(params[:id])
      @post = Discontent::Post.find(params[:post_id])
      if @post_group.one_last_post? && boss?
        @post.update_attributes(status: 0, discontent_post_id: nil)
        @post_group.update_column(:status, 3)
        redirect_to action: 'index'
      else
        @post.update_attributes(status: 0, discontent_post_id: nil)
        @post_group.destroy_ungroup_aspects(@post)
        respond_to do |format|
          format.js
        end
      end
    end

    #перевод группы в обязательные и обратно
    def set_required
      @post_group = Discontent::PostGroup.find(params[:id])
      if boss? || role_expert?
        if @post_group.status == 2
          @post_group.update_attributes(status: 4)
        elsif @post_group.status == 4
          @post_group.update_attributes(status: 2)
        end
      end
    end

    #создание группы из несовершенства
    def set_grouped
      @post = Discontent::Post.find(params[:id])
      @post_group = @project.discontent_groups.create(style: @post.style, content: @post.content, whered: @post.whered, whend: @post.whend)
      @post.update_attributes(status: 1, discontent_post_id: @post_group.id)
      @post_group.update_union_post_aspects(@post.post_aspects)
    end

  end

  def set_aspects
    @aspects = @project.proc_main_aspects
  end

  def set_accepted_posts
    @accepted_posts = @project.discontents.by_status([2, 4])
  end

  def discontent_post_group_params
    params.require(:discontent_post_group).permit(:content, :whend, :whered, :style)
  end
end