module PostNotes
  extend ActiveSupport::Concern

  def new_note
    @post = current_model.find(params[:id])
    @type = params[:type_field]
    @post_note = note_model.new
  end

  def create_note
    @post = current_model.find(params[:id])
    @type = params[name_of_note_for_param][:type_field]
    @post_note = @post.notes.build(params[name_of_note_for_param])
    @post_note.user = current_user

    current_user.journals.build(type_event: 'my_'+name_of_note_for_param, user_informed: @post.user, project: @project, body: trim_content(@post_note.content), first_id: @post.id, personal: true, viewed: false).save!

    @post.update_attributes(column_for_type_field(name_of_note_for_param, @type.to_i) => 'f')
    if @type && @post.instance_of?(Concept::Post) && @post.send(column_for_type_field(name_of_note_for_param, @type.to_i)) == true
      @post.user.add_score(type: :to_archive_plus_field, project: @project, post: @post, path: @post.class.name.underscore.pluralize, type_field: column_for_type_field(name_of_note_for_param, @type.to_i))
    end

    respond_to do |format|
      if @post_note.save
        format.js
      else
        format.js { render action: "new_note" }
      end
    end
  end

  def destroy_note
    @post = current_model.find(params[:id])
    @type = params[:type_field]
    @post_note = note_model.find(params[:note_id])
    @post_note.destroy if boss?
  end
end
