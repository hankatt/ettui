module QuotesHelper
	def url_to_hostname(url)
		if URI.parse(url).host.nil?
			url = URI.unescape(url)
		end

		URI.parse(url).host.sub(/\Awww\./, '')
	end

	def merge_tags(tags, new_tag)
		@tags = ""
		if tags.empty?
			@tags << new_tag
		else
			if tags.count >= 1
				# STRINGIFY EXISTING TAGS
				@quote.tags.each do |tag|
					if tag.eql?(tags.first)
						@tags << tag.to_s
					else
						@tags << ", " << tag.to_s
					end
				end

				# ADD THE NEW TAG
				@tags << ", " << new_tag
			end
		end

		# ADD NEW TAG TO QUOTE @quote.tag_list
		@quote.tag_list.add(new_tag)
		@quote.save

		# RETURN @tags STRING
		@tags
	end
end
