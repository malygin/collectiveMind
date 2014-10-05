

module Estimate::PostsHelper
	def estimate_trans(e)
    case e
      when 0
        t('form.estimate.chance_1')
      when 0.125
        t('form.estimate.chance_2')
      when 0.5
        t('form.estimate.chance_3')
      when 0.875
        t('form.estimate.chance_4')
    end
  end

  def estimate_trans_all(e)
    case e
      when 1
        t('form.estimate.chance_1')
      when 2
        t('form.estimate.chance_2')
      when 3
        t('form.estimate.chance_3')
      when 4
        t('form.estimate.chance_4')
    end
  end

  def estimate_trans_project(e)
		case e
      when 0
        t('form.estimate.grade_0')
			when 1
        t('form.estimate.grade_1')
			when 2
        t('form.estimate.grade_2')
      when 3
        t('form.estimate.grade_3')
		end
	end

	def css_class_estimate(e)
		case e
      when 0
        'text-danger'
			when 0.125
				'text-danger'
			when 0.5
				'text-warning'
      when 0.875
				'text-success'
		end
  end

  def css_class_estimate_all(e)
    case e
      when 1
        'color-dark-red'
      when 2
        'color-red'
      when 3
        'color-orange'
      when 4
        'color-green'
    end
  end

  def estimate_trans_simple(field,val)
    if field == 'on'
      case val
        when 4
          t('form.estimate.fullness_9')
        when 3
          t('form.estimate.fullness_10')
        when 2
          t('form.estimate.fullness_11')
        when 1
          t('form.estimate.fullness_12')
      end
    elsif field == 'ozs'
      case val
        when 4
          t('form.estimate.select_4')
        when 3
          t('form.estimate.select_3')
        when 2
          t('form.estimate.select_2')
        when 1
          t('form.estimate.select_0')
      end
    elsif field == 'op'
      case val
        when 4
          t('form.estimate.fullness_13')
        when 3
          t('form.estimate.fullness_14')
        when 2
          t('form.estimate.fullness_15')
        when 1
          t('form.estimate.fullness_16')
      end
    elsif field == 'ozf' or field == 'nep1' or field == 'nepr1'
      case val
        when 4
          t('form.estimate.select_4')
        when 3
          t('form.estimate.select_3')
        when 2
          t('form.estimate.select_2')
        when 1
          t('form.estimate.select_0')
      end
    end
  end
  def css_class_estimate_simple(e)
    case e
      when 1
        'color-dark-red'
      when 2
        'color-red'
      when 3
        'color-orange'
      when 4
        'color-green'
    end
  end

  def vote_post?(post)
    user_vote_post = current_user.voted_plan_posts.by_project(@project.id).first
    unless user_vote_post.nil?
      return true if user_vote_post == post
    end
    false
  end

  def css_class_estimate_form_select(e)
    case e
      when 1
        'color-grey'
      when 2
        'color-red'
      when 3
        'color-orange'
      when 4
        'color-green'
    end
  end
end
