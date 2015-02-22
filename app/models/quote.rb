class Quote < ActiveRecord::Base

	has_and_belongs_to_many :boards
	belongs_to :source
  	has_and_belongs_to_many :tags

	delegate :favicon, to: :source

	def self.in_board(board)
		board.quotes
	end

	def self.filter_by_source_ids(source_ids)
		if source_ids.empty?
			all
		else
			where(source_id: source_ids)
		end
	end

	def self.filter_by_text(filter_text)
		where("text LIKE ?", "%#{filter_text}%")
	end
	
	# Returns quotes created inbetween a given datetime range
	def self.range(from, til)
		where("created_at > ? AND created_at < ?", from, til)
	end

	# Returns quotes from the past week
	def self.from_past_week
		where("created_at >= ?", Date.today.prev_week)
	end

	# Returns quotes from the past month
	def self.from_past_month
		where("created_at >= ?", Date.today.prev_month)
	end

	def has_tag(tag_name)
		if tags.empty?
			return false
		else
			tags.any? do |tag|
				tag.name == tag_name
			end
		end
	end

	def update_readability_data
		# URL to Readability's Parser API
    	uri = URI('http://www.readability.com/api/content/v1/parser')
    	token = '34831792edfc0cf8e42b3e82086f00970a53407b'

        # Format params for web encoding
        uri.query = URI.encode_www_form({:url => url, :token => token })
        
        # Readability Parser response
        response = Net::HTTP.get_response(uri)
        parsed = ActiveSupport::JSON.decode(response.body)

        # Attributes to update
        title = parsed["title"]
        author = parsed["author"]

        # Validate that it is just the author
        # Assume most names won't use more than 4 names tops
        # Assume most names won't be that long, 34 chars tops
        if author.nil? || author.scan(/\w+/).size > 4 || author.length > 34
          author = nil
        end

        # Update attributes
        update(
          :readability_title => title, 
          :readability_author => author
        )
	end

	def add_tag(tag)

		# Helps determine if add is successful
		tag_list_count = tag_list.count

		# Try to add 'tag'
		tag_list.add(tag)
		save
		reload

		if(tag_list.count > tag_list_count)
			# Update the relationship to the board
			update_board_ownership(self)
		end

		return tag_list.count > tag_list_count
	end

	def remove_tag(tag)

		# Helps determine if remove is successful
		tag_list_count = tag_list.count

		# Try to add new_tag
		tag_list.remove(tag)
		save
		reload

		if(tag_list.count < tag_list_count)
			# Update the relationship to the board
			update_board_ownership(self)
		end

		tag_list.count < tag_list_count
	end

	def truncated_readability_title
		readability_title.truncate(64)
	end

	def unique_tags
		tags.uniq
	end

	def classes_for(user)
	  if new_since_last(user)
	    default_classes << " unread"
	  else
	    default_classes
	  end
	end

	def default_classes
	  "quote q-#{id}"
	end

	def new_since_last(user)
		created_at > user.last_active_at
	end

	def font_size
		case
		when text.length < 111
			"small"
		when text.length > 193
			"big"
		else
			""
		end
	end

	def source_date
		"#{created_at_day} #{created_at.strftime("%b")}"
	end
	
	def created_at_day
		created_at.day
	end

	private
	def update_board_ownership(quote)
		board = quote.boards.first
		board.tag(quote, :with => quote.tag_list, :on => "tags")
		board.reload
	end
end
