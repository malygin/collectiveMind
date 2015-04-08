module DiscontentUnion
  extend ActiveSupport::Concern

  included do
    attr_reader :discontent
  end

  module ClassMethods
    def union_discontent
      @post = Discontent::Post.find(params[:id])
      @new_post = @project.discontent_post.create(status: 2, style: @post.style, content: params[:union_post_descr], whered: @post.whered, whend: @post.whend)
      @new_post.save!
      unless params[:posts].nil?
        params[:posts].each do |p|
          post = Discontent::Post.find(p)
          post.update_attributes(status: 1, discontent_post_id: @new_post.id)
          @new_post.update_union_post_aspects(post.post_aspects)
        end
      end
      @post.update_attributes(status: 1, discontent_post_id: @new_post.id)
      @new_post.update_union_post_aspects(@post.post_aspects)
      redirect_to discontent_post_path(@project, @new_post)
    end

    def unions
      @accepted_posts = @project.discontent_post.by_status([2, 4])
      @posts = current_model.where(project_id: @project).where(status: [2, 4]).created_order
      respond_to do |format|
        format.js
      end
    end

    def remove_union
      @post = Discontent::Post.find(params[:id])
      @union_post = Discontent::Post.find(params[:post_id])
      if @post.one_last_post? and boss?
        @union_post.update_attributes(status: 0, discontent_post_id: nil)
        @post.update_column(:status, 3)
        redirect_to action: 'index'
      else
        @union_post.update_attributes(status: 0, discontent_post_id: nil)
        @post.destroy_ungroup_aspects(@union_post)
        respond_to do |format|
          format.js
        end
      end
    end

    def ungroup_union
      @post = Discontent::Post.find(params[:id])
      unless @post.discontent_posts.nil?
        @post.discontent_posts.each do |post|
          post.update_attributes(status: 0, discontent_post_id: nil)
        end
      end
      @post.update_column(:status, 3)
      redirect_to action: 'index'
    end

    def add_union
      @post = Discontent::Post.find(params[:id])
      @union_post = Discontent::Post.find(params[:post_id])
      @union_post.update_attributes(status: 1, discontent_post_id: @post.id)
      @post.update_union_post_aspects(@union_post.post_aspects)
    end

    def set_required
      @post = Discontent::Post.find(params[:id])
      if boss? or role_expert?
        if @post.status == 2
          @post.update_attributes(status: 4)
        elsif @post.status == 4
          @post.update_attributes(status: 2)
        end
      end
    end

    def set_grouped
      @post = Discontent::Post.find(params[:id])
      @new_post = @project.discontent_post.create(status: 2, style: @post.style, content: @post.content, whered: @post.whered, whend: @post.whend)
      @post.update_attributes(status: 1, discontent_post_id: @new_post.id)
      @new_post.update_union_post_aspects(@post.post_aspects)
    end
  end
end
