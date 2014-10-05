
module Concept::PostsHelper
	def can_vote_for_task?(task)
		task.voitings.each do |fr|
			if fr.user == current_user	
				return false
			end
		end
		return true
  end

  def get_concept_posts_for_vote?(project)
    disposts = Discontent::Post.where(project_id: project, status: 4).order(:id)
    last_vote = current_user.concept_post_votings.by_project_votings(project).last
    unless last_vote.nil?
      i = -1
      while disposts[i].nil? ? false:true
        @concept_posts = disposts[i].dispost_concepts.order('concept_posts.id')
        if @concept_posts.size > 1
          break
        end
        i -= 1
      end
      if disposts[i].id == last_vote.discontent_post_id
        count_now = current_user.concept_post_votings.by_project_votings(project).where(discontent_post_id: last_vote.discontent_post_id, concept_post_aspect_id: last_vote.concept_post_aspect_id).count
        index = @concept_posts.index last_vote.concept_post_aspect.concept_post
        index = count_now unless index == count_now
        if @concept_posts[index+1].nil?
          return false
        end
      end
    end
    true
  end

  def able_concept_posts_for_vote(disposts,last_vote, num = 0)
    unless last_vote.nil?
      dis_post = last_vote.discontent_post
      num = disposts.index dis_post
    end
    i = num.nil? ? 0 : num
    while disposts[i].nil? ? false:true
      @discontent_post = disposts[i]
      concept_posts = @discontent_post.dispost_concepts.by_status(0).order('concept_posts.id')
      if last_vote.nil?
        if concept_posts.size > 1
          return @discontent_post
        end
      elsif @discontent_post.id != last_vote.discontent_post_id
        if concept_posts.size > 1
          return @discontent_post
        end
      else
        count_now = current_user.concept_post_votings.by_project_votings(@project).where(discontent_post_id: last_vote.discontent_post_id, concept_post_aspect_id: last_vote.concept_post_aspect_id).count
        index = concept_posts.index last_vote.concept_post_aspect.concept_post
        index = count_now unless index == count_now
        unless concept_posts[index+1].nil?
          return @discontent_post
        end
      end
      i += 1
    end
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
        'control'
      when 8
        'control_r'
      when 9
        'obstacles'
      when 10
        'problems'
      when 11
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

  def status_for_concept_type(pa)
    stat_p = Concept::Post.stat_fields_positive(pa.id)
    stat_n = Concept::Post.stat_fields_negative(pa.id)
    if stat_p.present?
      content_tag :span, t('show.concept.check'), class: 'color-green'
    elsif stat_n.present?
      content_tag :span, t('show.concept.notes'), class: 'color-red'
    else
      content_tag :span, t('show.concept.check_now')
    end
  end

  def class_for_concept_type_field(post,type_fd)
    stat = post.send(column_for_concept_type(type_fd))
    if stat == true
      'color-green'
    elsif stat == false
      'color-red'
    else
      'color-orange'
    end
  end

  def status_for_concept(concept)
    add_score = 0

    if concept.name.present?
      add_score+=1
    end
    if concept.content.present?
      add_score+=1
    end
    if concept.positive.present?
      add_score+=1
    end
    if concept.negative.present?
      add_score+=1
    end
    if concept.problems.present?
      add_score+=1
    end
    if concept.reality.present?
      add_score+=1
    end
    if concept.concept_post.concept_post_resources.by_type('positive_r').present?
      add_score+=1
    end
    if concept.concept_post.concept_post_resources.by_type('negative_r').present?
      add_score+=1
    end
    "#{(add_score/8.to_f)*100}%"
  end

  def complite(post)
    concept = (@concept_post or @post)
    concept_post_discontent = post.concept_post_discontents.by_concept(concept.id).first if concept
    concept_post_discontent.present? ? concept_post_discontent.complite : 3
  end

  def level_complite(level)
    if level == 1
      "#{t('show.concept.complite')} #{t('show.concept.complite_1')}"
    elsif level == 2
      "#{t('show.concept.complite')} #{t('show.concept.complite_2')}"
    elsif level == 3
      "#{t('show.concept.complite')} #{t('show.concept.complite_3')}"
    else
      t('show.concept.not_use')
    end
  end

  def status_for_complite_discontent(post,pa)
    if post.concept_post_discontents.by_concept(pa.id).first
      complite = post.concept_post_discontents.by_concept(pa.id).first.complite
    end
    if complite == 1
      t('show.concept.complite_1')
    elsif complite == 2
      t('show.concept.complite_2')
    elsif complite == 3
      t('show.concept.complite_3')
    else
      t('show.concept.not_use')
    end
  end

end
