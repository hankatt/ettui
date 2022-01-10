class SessionsController < ApplicationController
  def new
    @user = User.new
    render "new", notice: :nil
    
  end

  def create

    authentication = ""
    
    if params[:email].nil?
      authenticate_with_http_basic do |email, password|
        authentication = Authentication.new(email, password)
      end
    else
      authentication = Authentication.new(params[:email], params[:password])
    end
    

    if authentication.successful?
      create_cookies_for(authentication.user)
      respond_to do |format|
        format.json { render json: { user_email: authentication.user.email, user_token: authentication.user.token, user_id: authentication.user.id } }
        format.html { redirect_logged_in(authentication.user) }
      end
    else
      redirect_to new_session_path
    end
  end

  def destroy
    session[:user_id] = nil
    session.delete(:user_id)
    redirect_to root_url
  end

private
  def create_cookies_for user
    session[:user_id] = user.id
  end
  def redirect_logged_in(user)
    if user.new_user
      redirect_to introduction_start_path
    else
      redirect_to board_path(user.board)
    end
  end
end
