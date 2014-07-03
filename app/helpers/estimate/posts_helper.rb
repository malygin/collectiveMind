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
      when 0
        'невероятно'
      when 1
        'маловероятно'
      when 2
        'вероятно'
      when 3
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
      when 0
        'text-danger'
      when 1
        'text-danger'
      when 2
        'text-warning'
      when 3
        'text-success'
    end
  end

  def estimate_trans_simple(field,val)
    if field == 'on'
      case val
        when 3
          'в полном объеме'
        when 2
          'в значительном объеме'
        when 1
          'в небольшом объеме'
        when 0
          'в ничтожном объеме'
      end
    elsif field == 'ozs'
      case val
        when 3
          'значительными'
        when 2
          'средними'
        when 1
          'незначительными'
        when 0
          'ничтожными'
      end
    elsif field == 'op'
      case val
        when 3
          'полностью'
        when 2
          'в значительной мере'
        when 1
          'в небольшой мере'
        when 0
          'в ничтожной мере'
      end
    elsif field == 'ozf'
      case val
        when 3
          'значительными'
        when 2
          'средними'
        when 1
          'незначительными'
        when 0
          'ничтожными'
      end
    end
  end
  def css_class_estimate_simple(e)
    case e
      when 0
        'text-danger'
      when 1
        'text-danger'
      when 2
        'text-warning'
      when 3
        'text-success'
    end
  end
end
