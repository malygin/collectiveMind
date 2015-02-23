class CollectInfo::PostsController < PostsController
  def voting_model
    Core::Aspect
  end

  def prepare_data
    @aspects = @project.aspects
  end

  def index
    @aspect = params[:asp] ? Core::Aspect.find(params[:asp]) : @project.aspects.order(:id).first
    @count_aspects = @project.main_aspects.count
    @count_aspects_check = 0
    @project.main_aspects.each do |asp|
      if asp.question_complete(@project, current_user).count == asp.questions.by_project(@project).by_status(0).count
        @count_aspects_check += 1
      end
    end
  end
end
