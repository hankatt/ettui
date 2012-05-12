class SessionsController < ApplicationController
  def new
    @quotes = Quote.limit(4).reverse_order
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

  def create_with_omniauth
    auth = request.env["omniauth.auth"]
    user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)
    if user
      cookies.permanent[:user_id] = user.id
      session[:user_id] = user.id
      redirect_to quotes_path, :notice => "Signed in!"
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
