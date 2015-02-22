class TagsController < ApplicationController
	before_action :find_quote

	def create
		# Ensure all tags are lowercase
		tag_params[:name] = tag_params[:name].downcase

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

	def add_tag_remote
		if params[:user_token]

			@user = User.find_by_token(params[:user_token])
			@quote = Quote.find(params[:qid])
			@board = @user.boards.first

			# Flags used to decide what to do with the UI
			@flags = { 
				:update => false,
				:add => false
			}

			# Important to downcase for searchability
			new_tag_name = URI.unescape(params[:tag]).downcase

			@tag = Tag.find_or_initialize_by(name: new_tag_name)

			if @tag.new_record? && @tag.valid?
				@tag.save

				# Tells the Bookmarklet Tag list to append the tag
				@flags[:add] = true
			else
				# Tells the Bookmarklet Tag list to update the tag status
				@flags[:update] = true
			end

			@quote.tags << @tag
		end

		respond_to do |format|
			data = { 
				:message => "has been added.", 
				:submessage => "Close this popup when done.", 
				:tag => @tag, 
				:add => @flags[:add], 
				:update => @flags[:update]
			}

			if @flags[:update]
				data = { 
					:message => "has been selected.", 
					:submessage => ""
				}
			else
				data = { 
					:message => "Tagging failed.", 
					:submessage => "You can also add tags on your board."
				}
			end

			# Respond with data{…} sent to the function added(…) in the bookmarklet
			format.json { render json: data, callback: "added"}
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