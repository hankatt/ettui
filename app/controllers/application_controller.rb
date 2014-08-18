class ApplicationController < ActionController::Base
 	protect_from_forgery

 	helper_method :current_user, :current_user_details, :get_tag_id

	private

	def current_user
	  @current_user ||= User.find(session[:user_id]) if session[:user_id]
	end


	def current_user_details
		if session[:user_id] && !current_user.uid.blank?
			# Twitter.user(current_user.uid.to_i)
		else
			nil
		end
	end

	def get_tag_id(name)
		current_user.boards.first.owned_tags.where(:name => name).first.id
		# current_user.boards.first.owned_tags.where(:name => name)[0].id
	end
end
