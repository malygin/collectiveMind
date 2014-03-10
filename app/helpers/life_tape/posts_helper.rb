module LifeTape::PostsHelper
	def trim_string(content, size = 200)
		if content.length > size
			return content[0..size]+" ..."
		end
		return content
	end
end
