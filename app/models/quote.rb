class Quote < ActiveRecord::Base

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
end
