module QuotesHelper
	def url_to_hostname(url)
		URI.parse(url).host.sub(/\Awww\./, '')
	end
end
