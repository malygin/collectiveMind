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

  def concepts_without_aspect
    concept_ongoing_post.includes(:concept_post_discontents).where(concept_post_discontents: { post_id: nil })
  end

  def get_free_votes_for(user, stage)
    case stage
      when :collect_info
        main_aspects.size - user.voted_aspects.by_project(id).size
      when :discontent
        discontents_for_vote.size - user.voted_discontent_posts.by_project(id).size
      when :concept
        concepts_for_vote.size - user.voted_concept_post.by_project(id).size
      when :novation
        novations.size - user.voted_novation_post.by_project(id).size
    end
  end

  def project_access(user)
    project.type_access == 0 ? true : (users.include?(user) || user.boss?)
  end

  def get_other_aspects_sorted_by(sort_rule)
    if sort_rule == 'sort_by_comments'
      other_aspects.sort_comments
    elsif sort_rule == 'sort_by_date'
      other_aspects.created_order
    else
      other_aspects
    end
  end

  def get_main_aspects_sorted_by(sort_rule)
    if sort_rule == 'sort_by_comments'
      main_aspects.sort_comments
    elsif sort_rule == 'sort_by_date'
      main_aspects.created_order
    else
      main_aspects
    end
  end

  # move to next stage if it '1:2' and we haven't '1:3' then go to '2:0', unless go to '1:3
  def go_to_next_stage
    if  stages[main_stage][:substages] && stages[main_stage][:substages][sub_stage + 1]
      self.stage = "#{main_stage}:#{sub_stage + 1}"
    else
      self.stage = "#{main_stage + 1}:0"
    end
    save
  end

  # move to prev stage if it '7:0' and we haven't '6:1' then go to '6:0', unless go to '6:1'
  def go_to_prev_stage
    if  sub_stage > 0
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
