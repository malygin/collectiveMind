module FrustrationsHelper
	def have_negative_comments?(frustration)
		frustration.frustration_comments.where(:negative => true).count != 0
	end
	def have_structure_comments?(frustration)
		frustration.frustration_comments.where(:negative => false).count != 0
	end


end
