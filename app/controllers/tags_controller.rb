class TagsController < ApplicationController
	before_action :find_quote

	def create
		tag = Tag.find_or_initialize_by(tag_params)

		if tag.new_record? && tag.valid?
			tag.save
		else
			# validations failed so you should let the user know
		end

		@quote.tags << tag

		respond_to do |format|
			format.html { redirect_to boards_path }
		end
	end

	def destroy
		tag = Tag.find(params[:id])

		if tag.last_instance?
			tag.destroy
		else
			@quote.tags.delete(tag)
		end

		respond_to do |format|
			format.html { redirect_to boards_path }
		end
	end

private
	def tag_params
		params.require(:tag).permit(:name)
	end

	def find_quote
		@quote = Quote.find(params[:quote_id])
	end
end