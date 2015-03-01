class ApplicationController < ActionController::Base
 	protect_from_forgery

 	helper_method :current_user, :record_user_activity

 	def set_titles left, right
		@left_title = left
		@right_title = right
	end

	private

	def current_user
		@current_user ||= User.find(cookies[:user_id]) if cookies[:user_id]
	end

	private
	
	def record_user_activity
		if current_user
			current_user.touch :last_active_at
		end
	end
end
