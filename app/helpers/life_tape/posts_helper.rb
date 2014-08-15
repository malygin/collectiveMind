module LifeTape::PostsHelper
	def trim_string(content, size = 200)
		if content.length > size
			return content[0..size]+" ..."
		end
		return content
  end

  def able_vote
    if @project.status == 2 and ((@project.stage1.to_i - current_user.voted_aspects.by_project(@project).size) != 0)
      return true
    end
    @number_v = @project.get_free_votes_for(current_user, 'lifetape', @project)
    if @number_v == 0 or @project.status != 2
      return false
    end
    false
  end
end
