class SessionsController < ApplicationController
  def new

  end

  def create
  	user = User.authenticate(params[:email], params[:password])
  	if user
      cookies.permanent[:user_id] = user.id
      session[:user_id] = user.id
  		redirect_to quotes_path, :notice => "Logged in!"
  	else
      redirect_to root_url, :notice => "Failed to authenticate!"
    end
  end

  def destroy
  	session[:user_id] = nil
    cookies.delete :user_id
    redirect_to root_url, :notice => "Logged out!"
  end
end
