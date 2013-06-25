class Quote < ActiveRecord::Base
	attr_accessible :text, :user_id, :url, :source_id
	belongs_to :user
	belongs_to :source

	def self.search(search)
		if search
			where('text LIKE ?', "%#{search}%")
		else
			all
		end
	end

	def self.get_sources(quotes)
		# a
	end
end
