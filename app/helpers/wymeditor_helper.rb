module WymeditorHelper
	def wymeditor_initialize(*dom_ids)
		output = []
		# unless(RAILS_ENV =~ /(production)|(test)/)
		# 	output << javascript_include_tag('/javascripts/wymeditor/wymeditor/jquery.wymeditor.js')
		# else
		# 	output << javascript_include_tag('/javascripts/wymeditor/wymeditor/jquery.wymeditor.pack.js')
		# end
	    output << javascript_include_tag('/javascripts/wymeditor/wymeditor/jquery.wymeditor.min.js')
		output << javascript_include_tag('/javascripts/wymrails.js')
		output << javascript_include_tag('/javascripts/wymeditor/wymeditor/plugins/resizable/jquery.wymeditor.resizable.js')
		output.join("\n")
	end
end