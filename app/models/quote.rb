class Quote < ActiveRecord::Base
	attr_accessible :text, :user_id, :url, :source_id
	belongs_to :user
	belongs_to :source

	def self.containing(search)
		if search
			where('text LIKE ?', "%#{search}%")
		else
			all
		end
	end

	def self.range(from, til)
		where("created_at > ? AND created_at < ?", from, til)
	end

	def self.from_past_week
		where("created_at >= ?", Date.today.prev_week)
	end

	def self.from_past_month
		where("created_at >= ?", Date.today.prev_month)
	end

	def self.foreign_keys(column, user_id)
		where(:user_id => user_id).group(column).count.keys
	end
end
