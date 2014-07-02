# encoding: utf-8

module Estimate::PostsHelper
	def estimate_trans(e,stat)
		case e
      when 0
        'невероятно'
			when 0.125
				'маловероятно'
			when 0.5
				'вероятно'
      when 0.850
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
      else
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
			else
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
			else
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
      else
        'text-success'
    end
  end

end
