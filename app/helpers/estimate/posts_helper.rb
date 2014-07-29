# encoding: utf-8

module Estimate::PostsHelper
	def estimate_trans(e)
    case e
      when 0
        'невероятно'
      when 0.125
        'маловероятно'
      when 0.5
        'вероятно'
      when 0.875
        'очень вероятно'
    end
  end

  def estimate_trans_all(e)
    case e
      when 1
        'невероятно'
      when 2
        'маловероятно'
      when 3
        'вероятно'
      when 4
        'очень вероятно'
    end
  end

  def estimate_trans_project(e)
		case e
      when 0
        'Отличный проект'
			when 1
				'Хороший проект'
			when 2
				'Удовлетворительный проект'
      when 3
				'Плохой проект'
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
          'в полном объеме'
        when 3
          'в значительном объеме'
        when 2
          'в небольшом объеме'
        when 1
          'в ничтожном объеме'
      end
    elsif field == 'ozs'
      case val
        when 4
          'значительными'
        when 3
          'средними'
        when 2
          'незначительными'
        when 1
          'ничтожными'
      end
    elsif field == 'op'
      case val
        when 4
          'полностью'
        when 3
          'в значительной мере'
        when 2
          'в небольшой мере'
        when 1
          'в ничтожной мере'
      end
    elsif field == 'ozf' or field == 'nep1' or field == 'nepr1'
      case val
        when 4
          'значительными'
        when 3
          'средними'
        when 2
          'незначительными'
        when 1
          'ничтожными'
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
