class SessionsController < ApplicationController

  def new
    @user = User.new
  end

  def create
  	@user = User.authenticate(params[:email], params[:password])
  	if @user
      cookies[:user_id] = { :value => @user.id, :expires => 3.months.from_now }
      if @user.new_user
        redirect_to intro_path
      else
        redirect_to @user.boards.first
      end
  	else
      redirect_to root_url, :notice => "Failed to authenticate!"
    end
  end

  def create_with_omniauth
    auth = request.env["omniauth.auth"]
    @user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)

    # Setting the Twitter user
    Twitter::Client.new(
      oauth_token: auth.credentials.token,
      oauth_token_secret: auth.credentials.secret,
    )

    # Create session if the authentication was successful
    if @user
      cookies[:user_id] = { :value => @user.id, :expires => 3.months.from_now }
      if @user.new_user
        redirect_to intro_path
      else
        redirect_to @user.boards.first
      end
    else
      redirect_to root_url, :notice => "Failed to authenticate!"
    end
  end

  def destroy
  	cookies.delete(:user_id)
    redirect_to root_url, :notice => "Logged out!"
  end

end
