# encoding: utf-8

module Estimate::PostsHelper
	def estimate_trans(e)
		case e
			when 1
				'не очень вероятно'
			when 2
				'вероятно'
			else
				'очень вероятно'
		end
	end

	def css_class_estimate(e)
		case e
			when 1
				'red_est'
			when 2
				'orange_est'
			else
				'green_est'
		end
	end
end
