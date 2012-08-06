module QuotesHelper

	def encodeURL(obj)
		@encoded = CGI::escape(obj.source.to_s).downcase!
	end

end
