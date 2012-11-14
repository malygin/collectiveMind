module LifeTape::PostsHelper
	def trim_string(content)
		if content.length > 500
			return content[0..500]+" ..."
		end
		return content
	end
end
