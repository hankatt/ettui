module QuotesHelper
	def url_to_host(url)
		URI.parse(url).host.sub(/\Awww\./, '')
	end
end
