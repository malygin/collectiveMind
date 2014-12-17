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
    color = "%06x" % (rand * 0xffffff)
    @aspect.color = color
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
    aspect_questions = @aspect.questions.by_project(@project.id).by_status(0).order("questions.id")
    if params[:answers]
      params[:answers].each do |answer|
        current_user.answers_users.create(answer_id: answer.to_i, project_id: @project.id, question_id: @question.id)
      end
    end
    @next_question = aspect_questions[(aspect_questions.index @question) + 1]
    @count_now = @aspect.question_complete(@project, current_user).count
    @count_all = @aspect.questions.by_project(@project.id).by_status(0).count
    unless @next_question
      @count_aspects = @project.aspects.main_aspects.count
      @count_aspects_check = 0
      @project.aspects.main_aspects.each do |asp|
        @count_aspects_check += 1 if asp.question_complete(@project, current_user).count == asp.questions.by_project(@project.id).by_status(0).count
      end
    end
  end
end
