class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    authentication = Authentication.new(params[:email], params[:password])

    if authentication.successful?
      create_cookies_for(authentication.user)
      redirect_logged_in(authentication.user)
    else
      redirect_to new_session_path, notice: "Failed to authenticate!"
    end
  end

  def destroy
    session[:user_id] = nil
    session.delete(:user_id)
    redirect_to root_url, notice: "Logged out!"
  end

  def create_with_omniauth
    auth = request.env["omniauth.auth"]
    @user = User.find_by(provider: auth["provider"], uid: auth["uid"]) || CreateWithOmni.create(auth)

    # Create session if the authentication was successful
    if @user
      create_cookies_for @user
    end

    redirect_to :back
  end

private
  def create_cookies_for user
    session[:user_id] = { value: user.id, expires: 3.months.from_now }
  end
  def redirect_logged_in(user)
    if user.new_user
      redirect_to intro_path
    else
      redirect_to board_path(user.board)
    end
  end
end
