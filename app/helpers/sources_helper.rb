module SourcesHelper

	def getHostname(url)
		URI.parse(url).host.sub(/\Awww\./, '')
	end

	def count_source_occurrences(id)
		current_user.boards.first.quotes.where(:source_id => id).count
	end

end
