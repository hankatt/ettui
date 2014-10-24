class Quote < ActiveRecord::Base

	acts_as_taggable
	has_and_belongs_to_many :boards
	belongs_to :source

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

	def append_tag(new_tag)
		@tags = new_tag

		tags.each do |tag|
			@tags << ", " << tag.name
		end

		return @tags
	end

	def remove_tag(tag_to_remove)
		@tags = ""

		tags.each do |tag|
			unless tag.name == tag_to_remove.name
				@tags << ", " << tag.name
			end
		end

		return @tags
	end
end
