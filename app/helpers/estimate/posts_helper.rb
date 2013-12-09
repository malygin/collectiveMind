# encoding: utf-8

module Estimate::PostsHelper
	def estimate_trans(e)
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
        'red_est'
			when 1
				'red_est'
			when 2
				'orange_est'
			else
				'green_est'
		end
	end
end
