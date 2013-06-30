class ApplicationController < ActionController::Base
 	protect_from_forgery

 	helper_method :current_user, :current_user_details

	private

	def current_user
	  @current_user ||= User.find(session[:user_id]) if session[:user_id]
	end

	def current_user_details
		Twitter.user(current_user.uid.to_i) if session[:user_id]
	end
end
