class Quote < ActiveRecord::Base

	belongs_to :user
	belongs_to :source

	# Returns quotes with content equal to 'search'
	def self.containing(search)
		if search
			where('text LIKE ?', "%#{search}%")
		else
			all
		end
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

	# Return a set of unique keys for the user 'user_id':s column 'column'
	def self.foreign_keys(column, user_id)
		where(:user_id => user_id).group(column).count.keys
	end
end
