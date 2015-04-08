module DiscontentGroup
  extend ActiveSupport::Concern

  included do
    attr_reader :discontent
  end

  module ClassMethods

    def new_group
      @asp = Core::Aspect.find(params[:asp]) unless params[:asp].nil?
      @aspects = Core::Aspect.where(project_id: @project, status: 0)
      @post_group = current_model.new
      respond_to do |format|
        format.js
      end
    end

    def create_group
      @post_group = @project.discontents.create(params[name_of_model_for_param])
      @post_group.status = 2
      @post_group.save
      unless params[:discontent_post_aspects].nil?
        params[:discontent_post_aspects].each do |asp|
          Discontent::PostAspect.create(post_id: @post_group.id, aspect_id: asp.to_i).save!
        end
      end
      @accepted_posts = @project.discontent_post.by_status([2, 4])
      respond_to do |format|
        format.js
      end
    end

    def union_group
      @post = Discontent::Post.find(params[:id])
      @new_post = Discontent::Post.find(params[:group_id])
      if @post and @new_post
        @post.update_attributes(status: 1, discontent_post_id: @new_post.id)
        @new_post.update_union_post_aspects(@post.post_aspects)
      end
      @type_tab = params[:type_tab]
      @parent_post = params[:parent_post_id]
      @accepted_posts = @project.discontent_post.by_status([2, 4])
      respond_to do |format|
        format.js
      end
    end

    def edit_group
      @asp = Core::Aspect.find(params[:asp]) unless params[:asp].nil?
      @aspects = Core::Aspect.where(project_id: @project, status: 0)
      @post_group = current_model.find(params[:id])
      @aspects_for_post = @post_group.post_aspects
      respond_to do |format|
        format.js
      end
    end

    def update_group
      @post_group = current_model.find(params[:id])
      unless params[:discontent_post_aspects].nil?
        @post_group.update_status_fields(params[name_of_model_for_param])
        @post_group.update_attributes(params[name_of_model_for_param])
        @post_group.update_post_aspects(params[:discontent_post_aspects])
      end
      @accepted_posts = Discontent::Post.where(project_id: @project, status: [2, 4])
      respond_to do |format|
        format.js
      end
    end
  end
end