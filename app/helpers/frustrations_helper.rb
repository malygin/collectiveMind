module FrustrationsHelper
	# check status frustration if structured - then use comment after structuring
	def have_negative_comments?(frustration)
		if frustration.structured?
			return frustration.comments_after_structuring.where(:negative => true).count != 0
		else 
			return frustration.comments_before_structuring.where(:negative => true).count != 0
		end
	end
	def have_structure_comments?(frustration)
		if frustration.structured?
			return frustration.comments_after_structuring.where(:negative => false).count != 0
		else
			return frustration.comments_before_structuring.where(:negative => false).count != 0
		end
	end

	# available only if frustrations<max and user hasnot structured and unstructured
	def active_form_frustration?
		not expert? and signed_in? and current_user.frustrations.count < Settings.max_frustration and current_user.structured_and_unstructured.count == 0
	end

	def show_link_to_structuring?(frustration)
		# current_user?(frustration.user) and (frustration.created_at < Settings.days_accept_unstracture.day.ago) and (frustration.status!=2)
		current_user?(frustration.user) and (frustration.status!=2)
	end

	def show_link_to_expert_with_negative_comments?(frustration)
		current_user?(frustration.user) and (frustration.created_at < Settings.days_accept_stracture.day.ago) and not @frustration.comments_after_structuring.empty?
	end

	def show_link_to_expert?(frustration)
		current_user?(frustration.user) and (frustration.created_at > Settings.days_accept_stracture.day.ago)
	end
	
	def frustration_in_expert_status?(frustration)
		frustration.status.between?(3,5) 
	end
	def frustration_after_expert?(frustration)
		frustration.status.between?(4,5)
	end
	def frustration_for_expert?(frustration)
		frustration.status == 3
	end

end
