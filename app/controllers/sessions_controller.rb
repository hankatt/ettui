class SessionsController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.authenticate(params[:email], params[:password])

    create_cookies_for @user
  end

  def create_with_omniauth
    auth = request.env["omniauth.auth"]
    @user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)

    # Create session if the authentication was successful
    create_cookies_for @user
  end

  def destroy
    session[:user_id] = nil
    cookies.delete(:user_id)
    redirect_to root_url, :notice => "Logged out!"
  end

private
  def create_cookies_for user
    if user
      cookies[:user_id] = { :value => user.id, :expires => 3.months.from_now }
      if user.new_user
        redirect_to intro_path
      else
        redirect_to user.boards.first
      end
    else
      redirect_to root_url, :notice => "Failed to authenticate!"
    end
  end
end
