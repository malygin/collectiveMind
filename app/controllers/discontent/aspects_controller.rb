class Discontent::AspectsController < ApplicationController
  before_filter :prepare_data, only: [:new, :edit]

  def current_model
    Discontent::Aspect
  end

  def prepare_data
    @project = Core::Project.find(params[:project])
    @aspects = Discontent::Aspect.where(project_id: @project)
  end

  def new
    @aspect = Discontent::Aspect.new
  end

  def create
    @project = Core::Project.find(params[:project])
    @aspect = @project.aspects.create(params[:discontent_aspect])
    @post = @aspect.life_posts.build(status: 0, project: @project)
    @aspect.life_tape_posts << @post
    redirect_to "/project/#{@project.id}/life_tape/posts?asp=#{@aspect.id}" if @post.save
  end

  def edit
    @aspect = Discontent::Aspect.find(params[:id])
  end

  def update
    @aspect = Discontent::Aspect.find(params[:id])
    @aspect.update_attributes(params[:discontent_aspect])
  end

  def destroy
    @aspect = Discontent::Aspect.find(params[:id])
    @aspect.destroy if boss?
    redirect_to life_tape_posts_path
  end

  def answer_question
    @project = Core::Project.find(params[:project])
    @aspect = Discontent::Aspect.find(params[:id])
    @question = Question.find(params[:question_id])
    if params[:answers]
      params[:answers].each do |answer|
        current_user.answers_users.create(answer_id: answer.to_i)
      end
    end
  end
end
