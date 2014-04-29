# encoding: utf-8
module Concept::PostsHelper
	def can_vote_for_task?(task)
		task.voitings.each do |fr|
			if fr.user == current_user	
				return false
			end
		end
		return true
  end

  def id_for_concept_type(type_fd)
    case type_fd
      when 1
        'name'
      when 2
        'content'
      when 3
        'positive'
      when 4
        'positive_r'
      when 5
        'negative'
      when 6
        'negative_r'
      when 7
        'problems'
      when 8
        'reality'
      else
        nil
    end
  end

  def class_for_concept_type(pa)
    stat_p = Concept::Post.stat_fields_positive(pa.id)
    stat_n = Concept::Post.stat_fields_negative(pa.id)
    if stat_p.present?
      'panel-p'
    elsif stat_n.present?
      'panel-n'
    else
      nil
    end
  end

  def class_for_concept_type_field(post,type_fd)
    stat = post.send(column_for_concept_type(type_fd))
    if stat == true
      'text-success'
    elsif stat == false
      'text-danger'
    else
      'text-info'
    end
  end
end
