class ProjectDecorator
  attr_reader :project

  def initialize(project)
    @project = project
  end

  def current_stage_type
    stages[main_stage][:type_stage]
  end

  def current_stage_name
    stages[main_stage][:name]
  end

  def current_stage_type_for_cabinet_url
    if stages[main_stage][:cabinet_url]
      stages[main_stage][:cabinet_url].to_s.downcase.singularize
    else
      stages[main_stage][:type_stage].to_s.downcase.singularize
    end
  end

  def current_stage_title
    stages[main_stage][:title_stage]
  end

  def count_folders
    # votes[main_stage][:count_folders]
    vote_folders.size
  end

  def vote_folders
    stages[main_stage][:folders]
  end

  def can_add?(name_controller)
    return false if name_controller.nil?
    name_controller == current_stage_type && stages[main_stage][:substages] && stages[main_stage][:substages][sub_stage][:status] == :add
  end

  # return main stage for stage '2:3' it will be 2
  def main_stage
    project.stage[0].to_i
  end

  # return main stage for stage '2:3' it will be 3, if  it '2' return 0
  def sub_stage
    project.stage[2] ? project.stage[2].to_i : 0
  end

  def type_for_questions
    project.stage == '1:0' ? 0 : 1
  end

  def closed?
    type_access == Core::Project::TYPE_ACCESS[:closed][:code]
  end

  def type_access_name
    Core::Project::TYPE_ACCESS[type_access]
  end

  def get_free_votes_for(user)
    send("#{current_stage_type}_for_vote").size - user.send("voted_#{current_stage_type}").by_project(id).size
  end

  # move to next stage if it '1:2' and we haven't '1:3' then go to '2:0', unless go to '1:3
  def go_to_next_stage
    if stages[main_stage][:substages] && stages[main_stage][:substages][sub_stage + 1]
      self.stage = "#{main_stage}:#{sub_stage + 1}"
    else
      self.stage = "#{main_stage + 1}:0"
    end
    save
  end

  # move to prev stage if it '7:0' and we haven't '6:1' then go to '6:0', unless go to '6:1'
  def go_to_prev_stage
    if sub_stage > 0
      self.stage = "#{main_stage}:#{sub_stage - 1}"
    else
      # if we haven't substages in STAGES  for prev stage, then we set new_sub_stage to 0
      new_sub_stage = (stages[main_stage - 1][:substages] ? (stages[main_stage - 1][:substages].size - 1) : 0)
      self.stage = "#{main_stage - 1}:#{new_sub_stage}"
    end
    save
  end

  def to_s
    project.id.to_s
  end

  def method_missing(method_name, *args, &block)
    project.send(method_name, *args, &block)
  end

  def respond_to_missing?(method_name, include_private = false)
    project.respond_to?(method_name, include_private) || super
  end
end
