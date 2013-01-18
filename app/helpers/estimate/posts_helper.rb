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
end
