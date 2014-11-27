module TagExtend
	extend ActsAsTaggableOn

	attr_accessor :context_count

	def update_tag_count_on(board) # Defines instance method
		self.context_count = board.owned_taggings.where(:tag_id => self.id).count
	end
end