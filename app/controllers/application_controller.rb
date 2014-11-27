class ApplicationController < ActionController::Base
 	protect_from_forgery

 	helper_method :current_user, :current_user_details, :record_user_activity

	private

	def current_user
		@current_user ||= User.find(cookies[:user_id]) if cookies[:user_id]
	end


	def current_user_details
		if cookies[:user_id] && !current_user.uid.blank?
			# Twitter.user(current_user.uid.to_i)
		else
			nil
		end
	end

	private
	
	def record_user_activity
		if current_user
			current_user.touch :last_active_at
		end
	end
end
