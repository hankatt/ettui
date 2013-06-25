module QuotesHelper

	def encodeURL(obj)
		@encoded = CGI::escape(obj.source.to_s).downcase!
	end

	def get_host(url)
		URI.parse(url).host.sub(/\Awww\./, '')
	end

end
